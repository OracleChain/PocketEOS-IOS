//
//  SideBarViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "SideBarViewController.h"
#import "TransactionRecordsViewController.h"
#import "PocketManagementViewController.h"
#import "PersonalSettingViewController.h"
#import "MessageFeedbackViewController.h"
#import "SystemSettingViewController.h"
#import "VersionUpdateViewController.h"
#import "MessageCenterViewController.h"
#import "LoginMainViewController.h"
#import "BBLoginViewController.h"
#import "AppDelegate.h"
#import "WalletQRCodeView.h"
#import "SideBarMainView.h"
#import "SideBarUpBackgroundView.h"
#import "CandyMainViewController.h"
#import "BackupAccountViewController.h"
#import "BPVoteViewController.h"
#import "BindPhoneNumberViewController.h"

@interface SideBarViewController ()<WalletQRCodeViewDelegate, SideBarMainViewDelegate >

@property(nonatomic, strong) WalletQRCodeView *walletQRCodeView;
@property(nonatomic , strong) SideBarMainView *sideBarMainView;
@property(nonatomic , strong) SideBarUpBackgroundView *sideBarUpBackgroundView;
@end

@implementation SideBarViewController

- (SideBarUpBackgroundView *)sideBarUpBackgroundView{
    if (!_sideBarUpBackgroundView) {
        _sideBarUpBackgroundView = [[SideBarUpBackgroundView alloc] initWithFrame:(CGRectMake(0, 0, 290,  STATUSBAR_HEIGHT))];
    }
    return _sideBarUpBackgroundView;
}

- (SideBarMainView *)sideBarMainView{
    if (!_sideBarMainView) {
        _sideBarMainView = [[[NSBundle mainBundle] loadNibNamed:@"SideBarMainView" owner:nil options:nil] firstObject];
        _sideBarMainView.delegate = self;
        _sideBarMainView.frame = CGRectMake(0, STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT);
    }
    return _sideBarMainView;
}

- (WalletQRCodeView *)walletQRCodeView{
    if (!_walletQRCodeView) {
        _walletQRCodeView = [[[NSBundle mainBundle] loadNibNamed:@"WalletQRCodeView" owner:nil options:nil] firstObject];
        _walletQRCodeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _walletQRCodeView.delegate = self;
        
    }
    return _walletQRCodeView;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setHidden: YES];
    Wallet *model = CURRENT_WALLET;
    if (IsStrEmpty(model.wallet_name)) {
        self.sideBarMainView.nameLabel.text = [NSString stringWithFormat:@"******的钱包"];
    }else{
        self.sideBarMainView.nameLabel.text = [NSString stringWithFormat:@"%@的钱包", model.wallet_name];
        
    }
    [self.sideBarMainView.avatarImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.wallet_img)) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sideBarUpBackgroundView];
    [self.view addSubview:self.sideBarMainView];
    
    
}

//SideBarMainViewDelegate
- (void)QRCodeBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.walletQRCodeView];
    // 钱包二维码
    Wallet *wallet = CURRENT_WALLET;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VALIDATE_STRING(wallet.wallet_name)  forKey:@"wallet_name"];
    [dic setObject:VALIDATE_STRING(wallet.wallet_img)  forKey:@"wallet_img"];
    [dic setObject:VALIDATE_STRING(wallet.wallet_uid)  forKey:@"wallet_uid"];
    [dic setObject:@"wallet_QRCode"  forKey:@"type"];
    
    //钱包二维码
    NSString *QRCodeJsonStr = [dic mj_JSONString];
    self.walletQRCodeView.walletQRCodeImg.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:QRCodeJsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
}

- (void)avatarBtnDidClick:(UIButton *)sender{
    PersonalSettingViewController *vc = [[PersonalSettingViewController alloc] init];
    [self cw_pushViewController:vc];
}

- (void)managePocketBtnDidClick:(id)sender{
    PocketManagementViewController *vc = [[PocketManagementViewController alloc] init];
    [self cw_pushViewController:vc];
}



- (void)transactionRecordBtnDidClick:(UIButton *)sender{
    TransactionRecordsViewController *vc = [[TransactionRecordsViewController alloc] init];
    [self cw_pushViewController:vc];
}

- (void)candyBtnDidClick:(UIButton *)sender{
    CandyMainViewController *vc = [[CandyMainViewController alloc] init];
    [self cw_pushViewController:vc];
}

- (void)messagesCenterBtnDidClick:(UIButton *)sender{
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self cw_pushViewController:vc];
}

-(void)bp_voteBtnDidClick:(UIButton *)sender{
    BPVoteViewController *vc = [[BPVoteViewController alloc] init];
    [self cw_pushViewController:vc];
    
}

- (void)feedBackBtnDidClick:(UIButton *)sender{
    MessageFeedbackViewController *vc = [[MessageFeedbackViewController alloc] init];
    [self cw_pushViewController:vc];
}

- (void)systemSettingDidClick:(UIButton *)sender{
    SystemSettingViewController *vc = [[SystemSettingViewController alloc ] init];
    [self cw_pushViewController:vc];
}

- (void)versionUpdateBtnDidClick:(UIButton *)sender{
    VersionUpdateViewController *vc = [[VersionUpdateViewController alloc ] init];
    [self cw_pushViewController:vc];
}

-(void)logoutBtnDidClick:(UIButton *)sender{
    // 到登录页面
    for (UIView *view in WINDOW.subviews) {
        [view removeFromSuperview];
    }
    [[NSUserDefaults standardUserDefaults] setObject: nil  forKey:Current_wallet_uid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIViewController *vc;
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        vc = [[LoginMainViewController alloc] init];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        vc = [[BBLoginViewController alloc] init];
    }
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: navi];
}

- (void)dissmissSidebarBtnDidClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
