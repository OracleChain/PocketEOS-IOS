//
//  ImportAccountPermisionViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountPermisionViewController.h"
#import "ImportAccountPermisionHeaderView.h"
#import "EOS_Key_Encode.h"
#import "Get_account_permission_service.h"


@interface ImportAccountPermisionViewController ()<ImportAccountPermisionHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ImportAccountPermisionHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) Get_account_permission_service *get_account_permission_service;
@end

@implementation ImportAccountPermisionViewController

{
    // 在本地根据私钥算出的公钥
    NSString *public_key_from_local;
    BOOL private_Key_is_validate;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"导入权限", nil)rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (ImportAccountPermisionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImportAccountPermisionHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT);
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

- (Get_account_permission_service *)get_account_permission_service{
    if (!_get_account_permission_service) {
        _get_account_permission_service = [[Get_account_permission_service alloc] init];
    }
    return _get_account_permission_service;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self configSubViews];
}

- (void)configSubViews{
    if (self.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportOwnerPrivateKey) {
        self.headerView.textView.placeholder = NSLocalizedString(@"请输入Owner key", nil);
        [self.headerView.resetPrivateKeyBtn setHidden:YES];
        self.navView.titleLabel.text = NSLocalizedString(@"导入Owner权限", nil);
        
    }else if (self.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportActivePrivateKey){
        
        self.headerView.textView.placeholder = NSLocalizedString(@"请输入Active key", nil);
        [self.headerView.resetPrivateKeyBtn setTitle:NSLocalizedString(@"不知道Active key？去重置", nil) forState:(UIControlStateNormal)];
        [self.headerView.resetPrivateKeyBtn setHidden:NO];
        self.navView.titleLabel.text = NSLocalizedString(@"导入Active权限", nil);
    }
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


// ImportAccountPermisionHeaderViewDelegate
- (void)importAccountPermisionHeaderViewResetPrivateKeyBtnDidClick{
    [TOASTVIEW showWithText:@"importAccountPermisionHeaderViewResetPrivateKeyBtnDidClick"];
}

-(void)importAccountPermisionHeaderViewConfirmBtnDidClick{
    if (IsStrEmpty(self.headerView.textView.text) ) {
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
    private_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.textView.text ];
    if (private_Key_is_validate == YES) {
        [self createPublicKeys];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
        [self removeLoginPasswordView];
        return ;
    }
}


- (void)createPublicKeys{
    // 将用户导入的私钥生成公钥
    public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.textView.text];
    // 请求该账号的公钥
    WS(weakSelf);
    self.get_account_permission_service.getAccountRequest.name = VALIDATE_STRING(self.model.account_name);
    [self.get_account_permission_service getAccountPermission:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportOwnerPrivateKey) {
                if ([weakSelf.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_from_local]) {
                    [weakSelf configAccountInfo];
                    
                }else{
                    [TOASTVIEW showWithText:NSLocalizedString(@"权限错误", nil)];
                }
            }else if(weakSelf.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportActivePrivateKey){
                if ([weakSelf.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_from_local]) {
                    [weakSelf configAccountInfo];
                }else{
                    [TOASTVIEW showWithText:NSLocalizedString(@"权限错误", nil)];
                }
            }
            
        }
    }];
}

// config account after import
- (void)configAccountInfo{
    NSString *account_private_key_save = [AESCrypt encrypt:self.headerView.textView.text password:self.loginPasswordView.inputPasswordTF.text];
    Wallet *wallet = CURRENT_WALLET;
    // update table
    BOOL result = false ;
    if (self.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportOwnerPrivateKey) {
        result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_owner_public_key = '%@', account_owner_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, public_key_from_local, account_private_key_save , self.model.account_name]];
    }else if(self.importAccountPermisionViewControllerCurrentAction == ImportAccountPermisionViewControllerCurrentActionImportActivePrivateKey){
        result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_active_public_key = '%@', account_active_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, public_key_from_local, account_private_key_save , self.model.account_name]];
    }
    
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
