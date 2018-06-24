//
//  CreateAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "CreateAccountHeaderView.h"
#import "NavigationView.h"
#import "AccountsTableManager.h"
#import "AccountInfo.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "CreateAccountService.h"
#import "CreateAccountRequest.h"
#import "EosPrivateKey.h"
#import "ImportAccountViewController.h"
#import "BBCreateAccountHeaderView.h"
#import "EOSMappingImportAccountViewController.h"
#import "RtfBrowserViewController.h"
#import "BackupAccountViewController.h"

@interface CreateAccountViewController ()<UIGestureRecognizerDelegate,  NavigationViewDelegate, CreateAccountHeaderViewDelegate, LoginPasswordViewDelegate, BBCreateAccountHeaderViewDelegate>
@property(nonatomic, strong) CreateAccountHeaderView *headerView;
@property(nonatomic , strong) BBCreateAccountHeaderView *bb_createAccountHeaderView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) CreateAccountService *createAccountService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@end

@implementation CreateAccountViewController

- (CreateAccountService *)createAccountService{
    if (!_createAccountService) {
        _createAccountService = [[CreateAccountService alloc] init];
    }
    return _createAccountService;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"创建新账号", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (CreateAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CreateAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT+40, SCREEN_WIDTH, 277);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (BBCreateAccountHeaderView *)bb_createAccountHeaderView{
    if (!_bb_createAccountHeaderView) {
        _bb_createAccountHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"BBCreateAccountHeaderView" owner:nil options:nil] firstObject];
        _bb_createAccountHeaderView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40);
        _bb_createAccountHeaderView.delegate = self;
    }
    return _bb_createAccountHeaderView;
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
    [self.view addSubview:self.bb_createAccountHeaderView];
    [self.view addSubview:self.headerView];
    [self configImportAccountBtn];
}

//CreateAccountHeaderViewDelegate
- (void)agreeTermBtnDidClick:(UIButton *)sender {
}
- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createAccountBtnDidClick:(UIButton *)sender {
    
    if (self.headerView.agreeItemBtn.isSelected) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请勾选同意条款!", nil)];
        return;
    }
    if (![ RegularExpression validateEosAccountName:self.headerView.accountNameTF.text ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"由小写字母开头的12位字符，只能由小写字母a~z和数字1~5组成。", nil)];
        return;
    }
    [self.view addSubview:self.loginPasswordView];
}

// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    [self createkeys];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)importAccount:(UIButton *)sender{
    ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configImportAccountBtn{
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:NSLocalizedString(@"如果已有账号，请点击这里导入", nil)forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:HEX_RGB_Alpha(0xFFFFFF, 0.7) forState:(UIControlStateNormal)];
    button.lee_theme
    .LeeAddButtonTitleColor(SOCIAL_MODE, HEX_RGB_Alpha(0x4D7BFE, 1), UIControlStateNormal)
    .LeeAddButtonTitleColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.7), UIControlStateNormal);
    [button addTarget:self action:@selector(importAccount:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view, MARGIN_20).rightSpaceToView(self.view, MARGIN_20).bottomSpaceToView(self.view, 23).heightIs(21);
}


/**
 生成注册eos账号需要的所有 key
 account_active_private_key;
 account_active_public_key;
 account_owner_private_key;
 account_owner_public_key;
 */
- (void)createkeys{
    WS(weakSelf);
    EosPrivateKey *ownerPrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    EosPrivateKey *activePrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    weakSelf.createAccountService.createEOSAccountRequest.uid = CURRENT_WALLET_UID;
    weakSelf.createAccountService.createEOSAccountRequest.eosAccountName = weakSelf.headerView.accountNameTF.text;
    weakSelf.createAccountService.createEOSAccountRequest.ownerKey = ownerPrivateKey.eosPublicKey;
    weakSelf.createAccountService.createEOSAccountRequest.activeKey = activePrivateKey.eosPublicKey;
    NSLog(@"{ownerPrivateKey:%@\neosPublicKey:%@\nactivePrivateKey:%@\neosPublicKey:%@\n}", ownerPrivateKey.eosPrivateKey, ownerPrivateKey.eosPublicKey, activePrivateKey.eosPrivateKey, activePrivateKey.eosPublicKey);
    // 创建eos账号
    
    [weakSelf.createAccountService createEOSAccount:^(id service, BOOL isSuccess) {
        
        if (isSuccess) {
            NSNumber *code = service[@"code"];
            if ([code isEqualToNumber:@0]) {
                // 创建账号成功
                [TOASTVIEW showWithText:NSLocalizedString(@"创建账号成功!", nil)];
                // 本地数据库添加账号
                AccountInfo *model = [[AccountInfo alloc] init];
                model.account_name = weakSelf.headerView.accountNameTF.text;
                model.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
                model.account_active_public_key = activePrivateKey.eosPublicKey;
                model.account_owner_public_key = ownerPrivateKey.eosPublicKey;
                model.account_active_private_key = [AESCrypt encrypt:activePrivateKey.eosPrivateKey password:weakSelf.loginPasswordView.inputPasswordTF.text];
                model.account_owner_private_key = [AESCrypt encrypt:ownerPrivateKey.eosPrivateKey password:weakSelf.loginPasswordView.inputPasswordTF.text];
                model.is_privacy_policy = @"0";
                NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
                if (accountsArr.count == 0) {
                    model.is_main_account = @"1";
                    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET wallet_main_account = '%@' WHERE wallet_uid = '%@'" , WALLET_TABLE , model.account_name, CURRENT_WALLET_UID]];
                }else{
                    model.is_main_account = @"0";
                }
                
                [[AccountsTableManager accountTable] addRecord: model];
                
                BackupAccountViewController *vc = [[BackupAccountViewController alloc] init];
                
                if (weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromCreatePocketVC) {
                    vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromCreatePocketVC;
                }else if(weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromPocketManagementVC){
                   vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromPocketManagementVC;
                }
                vc.accountName =  weakSelf.headerView.accountNameTF.text ;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                [weakSelf.loginPasswordView removeFromSuperview];
                
            }else{
                [TOASTVIEW showWithText:VALIDATE_STRING(service[@"message"])];
            }
            
        }
        
    }];
}


//BBCreateAccountHeaderViewDelegate
- (void)createAccountUseEOSPrivateKey{
    EOSMappingImportAccountViewController *vc = [[EOSMappingImportAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
