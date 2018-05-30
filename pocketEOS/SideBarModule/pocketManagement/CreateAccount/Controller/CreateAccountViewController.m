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
#import "LoginPasswordView.h"
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
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"创建新账号" rightBtnImgName:@"" delegate:self];
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
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    if (![ RegularExpression validateEosAccountName:self.headerView.accountNameTF.text ]) {
        [TOASTVIEW showWithText:@"您的输入不匹配!^[1-5a-z]{7,13}$"];
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
        [TOASTVIEW showWithText:@"密码输入错误!"];
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
    [button setTitle:@"如果已有账号，请点击这里导入" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
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
    weakSelf.createAccountService.createAccountRequest.account_name = weakSelf.headerView.accountNameTF.text;
    weakSelf.createAccountService.createAccountRequest.owner_key = ownerPrivateKey.eosPublicKey;
    weakSelf.createAccountService.createAccountRequest.active_key = activePrivateKey.eosPublicKey;
    
    // 创建eos账号
    [weakSelf.createAccountService createAccount:^(id service, BOOL isSuccess) {
        
        if (isSuccess) {
            NSNumber *code = service[@"code"];
            if ([code isEqualToNumber:@0]) {
                // 创建账号成功
                [TOASTVIEW showWithText:@"创建账号成功!"];
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
                
                weakSelf.createAccountService.backupEosAccountRequest.uid = CURRENT_WALLET_UID;
                weakSelf.createAccountService.backupEosAccountRequest.eosAccountName = model.account_name;
                [weakSelf.createAccountService backupAccount:^(id service, BOOL isSuccess) {
                    NSNumber *code = service[@"code"];
                    if ([code isEqualToNumber:@0]) {
                        NSLog(@"给用户添加新的eos账号到服务器成功!");
                    }
                }];
                
                BackupAccountViewController *vc = [[BackupAccountViewController alloc] init];
                
                if (weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromCreatePocketVC) {
                    vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromCreatePocketVC;
                }else if(weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromPocketManagementVC){
                   vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromPocketManagementVC;
                }
                vc.accountName =  weakSelf.headerView.accountNameTF.text ;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                

                
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
