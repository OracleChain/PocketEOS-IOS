//
//  EOSMappingImportAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSMappingImportAccountViewController.h"
#import "EOSMappingImportAccountHeaderView.h"
#import "NavigationView.h"
#import "GetAccountNameByWifRequest.h"
#import "EOSMappingResult.h"
#import "EOS_Key_Encode.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"

@interface EOSMappingImportAccountViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, EOSMappingImportAccountHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) EOSMappingImportAccountHeaderView *headerView;

@property(nonatomic, strong) GetAccountNameByWifRequest *getAccountNameByWifRequest;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@end

@implementation EOSMappingImportAccountViewController

{   // 从网络获取的公钥
    NSString *active_public_key_from_network;
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *active_public_key_from_local;
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
    BOOL private_active_Key_is_validate;
}

- (GetAccountNameByWifRequest *)getAccountNameByWifRequest{
    if (!_getAccountNameByWifRequest) {
        _getAccountNameByWifRequest = [[GetAccountNameByWifRequest alloc] init];
    }
    return _getAccountNameByWifRequest;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"映射账号录入", nil)rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (EOSMappingImportAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EOSMappingImportAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 230);
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
}

- (void)importEOSMappingAccountBtnDidClick{
    if (IsStrEmpty(self.headerView.privateKeyTF.text) ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"输入框不能为空!", nil)];
        return;
    }else{
        private_active_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.privateKeyTF.text];
        if (!private_active_Key_is_validate) {
            [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
            return;
        }else{
            [self.view addSubview:self.loginPasswordView];
        }
    }
}


// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    [self checkLocalDatabaseAlreadyHasAccountWithAccountName:VALIDATE_STRING(self.headerView.privateKeyTF.text)];
}

// 检查本地是否有对应的账号
- (void)checkLocalDatabaseAlreadyHasAccountWithAccountName:(NSString *)accountName{
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:accountName];
    if (accountInfo) {
        [TOASTVIEW showWithText:NSLocalizedString(@"本地钱包已存在该账号!", nil)];
        return;
    }
    [self importEOSMappingAccount];
}

- (void)importEOSMappingAccount{
    // 请求该账号的公钥
    WS(weakSelf);
    active_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.privateKeyTF.text];
    self.getAccountNameByWifRequest.public_key = VALIDATE_STRING(active_public_key_from_local) ;
    [self.getAccountNameByWifRequest postOuterDataSuccess:^(id DAO, id data) {
        
        EOSMappingResult *result = [EOSMappingResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.msg];
        }else{
            if (result.account_names.count > 0) {
                // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                AccountInfo *accountInfo = [[AccountInfo alloc] init];
                accountInfo.account_name = result.account_names[0];
                accountInfo.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
                accountInfo.account_active_public_key = active_public_key_from_local;
                accountInfo.account_owner_public_key = active_public_key_from_local;
                accountInfo.account_active_private_key = [AESCrypt encrypt:weakSelf.headerView.privateKeyTF.text password:weakSelf.loginPasswordView.inputPasswordTF.text];
                accountInfo.account_owner_private_key = accountInfo.account_active_private_key;
                accountInfo.is_privacy_policy = @"0";
                
                NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
                if (accountsArr.count > 0) {
                    accountInfo.is_main_account = @"0";
                }else{
                    accountInfo.is_main_account = @"1";
                }
                [[AccountsTableManager accountTable] addRecord:accountInfo];
                [TOASTVIEW showWithText:NSLocalizedString(@"账号导入成功!", nil)];
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
                
                
            }else{
                [TOASTVIEW showWithText:@"未查到对应账号!"];
            }
            [weakSelf.loginPasswordView removeFromSuperview];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
        [weakSelf.loginPasswordView removeFromSuperview];
    }];
    
}

//  NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
