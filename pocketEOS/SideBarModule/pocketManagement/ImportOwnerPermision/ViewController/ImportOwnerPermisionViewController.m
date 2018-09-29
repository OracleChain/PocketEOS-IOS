//
//  ImportOwnerPermisionViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/30.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportOwnerPermisionViewController.h"
#import "ImportOwnerPermisionHeaderView.h"
#import "EOS_Key_Encode.h"
#import "GetAccountRequest.h"
#import "GetAccountResult.h"
#import "GetAccount.h"
#import "Permission.h"


@interface ImportOwnerPermisionViewController ()<ImportOwnerPermisionHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ImportOwnerPermisionHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@end

@implementation ImportOwnerPermisionViewController
{   // 从网络获取的公钥
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"导入Owner权限", nil)rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (ImportOwnerPermisionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImportOwnerPermisionHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 160);
    }
    return _headerView;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}
- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//ImportOwnerPermisionHeaderViewDelegate
- (void)importBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.headerView.private_ownerKey_TF.text) ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请保证输入信息的完整~", nil)];
        return;
    }else{
        [self.view addSubview:self.loginPasswordView];
    }
}

// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self removeLoginPasswordView];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    
    // 验证 owner_private_key 是否匹配
    [self validateInputFormat];
}

// 检查输入的格式
- (void)validateInputFormat{
    // 验证私钥格式是否正确
    private_owner_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.private_ownerKey_TF.text ];
    if (private_owner_Key_is_validate == YES) {
        [self createPublicKeys];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
        [self removeLoginPasswordView];
        return ;
    }
}


- (void)createPublicKeys{
    // 将用户导入的私钥生成公钥
    owner_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.private_ownerKey_TF.text];
    // 请求该账号的公钥
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(self.model.account_name) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            for (Permission *permission in model.permissions) {
                if ([permission.perm_name isEqualToString:@"owner"]) {
                    owner_public_key_from_network = permission.required_auth_key;
                }
            }
            
            if ([owner_public_key_from_network isEqualToString: owner_public_key_from_local]) {
                // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                [weakSelf configAccountInfo];
            }else{
                [TOASTVIEW showWithText:NSLocalizedString(@"导入的私钥不匹配!", nil)];
            }
            
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// config account after import
- (void)configAccountInfo{
    
    NSString *account_owner_private_key_save = [AESCrypt encrypt:self.headerView.private_ownerKey_TF.text password:self.loginPasswordView.inputPasswordTF.text];
    Wallet *wallet = CURRENT_WALLET;
    // update table
    BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_owner_public_key = '%@', account_owner_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, owner_public_key_from_local, account_owner_private_key_save , self.model.account_name]];
    if (result) {
        [TOASTVIEW showWithText:NSLocalizedString(@"导入私钥成功", nil)];
    }else{
        NSLog(@"导入私钥失败");
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

@end
