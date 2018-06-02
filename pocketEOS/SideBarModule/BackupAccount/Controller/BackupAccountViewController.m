//
//  BackupAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BackupAccountViewController.h"
#import "NavigationView.h"
#import "BackupAccountHeaderView.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LoginPasswordView.h"

@interface BackupAccountViewController ()<NavigationViewDelegate,BackupAccountHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) BackupAccountHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@end

@implementation BackupAccountViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"备份EOS账号" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (BackupAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BackupAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.accountName = self.accountName;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 460);
        _headerView.delegate = self;
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

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//BackupAccountHeaderViewDelegate
- (void)confirmSwitchDidOn{
    [self.view addSubview:self.loginPasswordView];
}

// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:@"密码输入错误!"];
        return;
    }
    
    AccountInfo *model = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.accountName];
    NSString *privateKeyStr = [NSString stringWithFormat:@"ACTIVEKEY：%@\nOWNKEY: %@\n", [AESCrypt decrypt:model.account_active_private_key password:self.loginPasswordView.inputPasswordTF.text], [AESCrypt decrypt:model.account_owner_private_key password:self.loginPasswordView.inputPasswordTF.text]];
    self.headerView.contentTextView.text = privateKeyStr;
    
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
    
}

- (void)backupConfirmBtnDidClick{
//    if (self.backupAccountViewControllerFromVC == BackupAccountViewControllerFromCreatePocketVC) {
        for (UIView *view in WINDOW.subviews) {
            [view removeFromSuperview];
        }
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
        
//    }else if(self.backupAccountViewControllerFromVC == BackupAccountViewControllerFromPocketManagementVC){
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}
@end
