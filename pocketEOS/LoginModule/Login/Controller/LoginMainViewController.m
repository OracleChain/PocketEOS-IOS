//
//  LoginMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginView.h"
#import "CreatePocketViewController.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LoginService.h"
#import "AuthResult.h"
#import "Wallet.h"
#import "SocialManager.h"
#import "SocialModel.h"
#import "BindPhoneNumberViewController.h"
#import "BBLoginViewController.h"
#import "RtfBrowserViewController.h"
#import "CreateAccountViewController.h"
#import "UserInfoResult.h"
#import "UserInfo.h"
#import "CountryCodeAreaViewController.h"
#import "AreaCodeModel.h"

@interface LoginMainViewController ()<UIGestureRecognizerDelegate, LoginViewDelegate, CountryCodeAreaViewControllerDelegate>
@property(nonatomic, strong) LoginService *mainService;
@property(nonatomic , strong) LoginView *loginView;
@property(nonatomic , strong) AreaCodeModel *areaCodeModel;
@end

@implementation LoginMainViewController

- (LoginService *)mainService{
    if (!_mainService) {
        _mainService = [[LoginService alloc] init];
    }
    return _mainService;
}

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil] firstObject];
        _loginView.delegate = self;
        _loginView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [LEETheme startTheme:SOCIAL_MODE];
    [self.view addSubview:self.loginView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

//LoginViewDelegate
- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeToBlackBoxMode{
    BBLoginViewController *vc = [[BBLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getVerifyBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.loginView.phoneTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"手机号不能为空!", nil)];
        return;
    }
    
    [self startCountDown];
    self.mainService.getVerifyCodeRequest.phoneNum = self.loginView.phoneTF.text;
    if (!IsNilOrNull(self.areaCodeModel)) {
        self.mainService.getVerifyCodeRequest.type = self.areaCodeModel.code;
    }else{
        self.mainService.getVerifyCodeRequest.type = @"86";
    }
    [self.mainService getVerifyCode:^(id service, BOOL isSuccess) {
        [TOASTVIEW showWithText: VALIDATE_STRING(service[@"message"]) ];
        if (isSuccess) {
            if ([service[@"code"] isEqualToValue:@0]) {
                // 发送短信成功
            }
        }
    }];
}

- (void)loginBtnDidClick:(UIButton *)sender{
    
    if (IsStrEmpty(self.loginView.phoneTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"手机号不能为空!", nil)];
        return;
    }
    if (![RegularExpression validateVerifyCode:self.loginView.verifyCodeTF.text] ) {
        [TOASTVIEW showWithText: NSLocalizedString(@"验证码格式有误!", nil)];
        return;
    }
    WS(weakSelf);
    self.mainService.authVerifyCodeRequest.phoneNum = self.loginView.phoneTF.text;
    self.mainService.authVerifyCodeRequest.code = self.loginView.verifyCodeTF.text;
    NSString *phoneNum = self.loginView.phoneTF.text;
    
    [self.mainService authVerifyCode:^(AuthResult *result, BOOL isSuccess) {
        if (isSuccess) {
            
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message) ];
            if ([result.code isEqualToNumber:@0]) {
                [[NSUserDefaults standardUserDefaults] setObject: result.data.wallet_uid  forKey:Current_wallet_uid];
                [[NSUserDefaults standardUserDefaults] synchronize];
                Wallet *wallet = CURRENT_WALLET;
                
                if (wallet) {
                    NSLog(@"%@", wallet.account_info_table_name);
                    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
                    if (accountArray.count > 0) {
                        // 如果本地有当前账号对应的钱包
                        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
                    }else{
                        CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
                        vc.createAccountViewControllerFromVC = CreateAccountViewControllerFromCreatePocketVC;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else{
                    
                    // 如果本地没有当前账号对应的钱包
                    Wallet *model = [[Wallet alloc] init];
                    if (phoneNum.length > 4) {
                        model.wallet_name = [phoneNum substringFromIndex:phoneNum.length - 4];
                    }else{
                        model.wallet_name = phoneNum;
                    }
                    model.wallet_name = model.wallet_name;
                    model.wallet_uid = result.data.wallet_uid;
                    model.wallet_phone = phoneNum;
                    model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
                    [[WalletTableManager walletTable] addRecord: model];
                    
                    // 创建钱包(本地数据库)
                    CreatePocketViewController *vc = [[CreatePocketViewController alloc] init];
                    vc.createPocketViewControllerFromMode = CreatePocketViewControllerFromSocialMode;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }
            }
        }
    }];
}

- (void)wechatLoginBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    [[SocialManager socialManager] wechatLoginRequest];
    [[SocialManager socialManager] setOnWechatLoginSuccess:^(SocialModel *model) {
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        BOOL result = NO;
        for (Wallet *wallet in allLocalWallet) {
            if ([wallet.wallet_weixin isEqualToString:model.unionid]) {
                // 如果本地有当前账号对应的钱包
                [[NSUserDefaults standardUserDefaults] setObject:wallet.wallet_uid  forKey:Current_wallet_uid];
                [[NSUserDefaults standardUserDefaults] synchronize];
                result = YES;
                break;
            }
        }
        
        if (result) {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
        }else{
            // 本地没有 wallet ,请求是否服务器绑定过钱包
            weakSelf.mainService.getUserInfoRequest.token = model.unionid;
            weakSelf.mainService.getUserInfoRequest.type = @1;
            weakSelf.mainService.getUserInfoRequest.from = @"login";
            [weakSelf.mainService getUserInfo:^(UserInfoResult *result, BOOL isSuccess) {
                if (isSuccess) {
                    if (IsStrEmpty(result.data.uid)) {
                        // 无此用户
                        // bind phone => createPocket
                        BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
                        vc.model = model;
                        vc.model.socialModelType = SocialTypeWechat;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        // 有这个用户
                        Wallet *wallet_wechat = [[Wallet alloc] init];
                        wallet_wechat.wallet_uid = result.data.uid;
                        [[NSUserDefaults standardUserDefaults] setObject:wallet_wechat.wallet_uid  forKey:Current_wallet_uid];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        wallet_wechat.wallet_phone = result.data.phoneNum;
                        wallet_wechat.wallet_avatar = result.data.avatar;
                        wallet_wechat.wallet_img = result.data.avatar;
                        wallet_wechat.wallet_weixin = result.data.wechat;
                        wallet_wechat.wallet_qq = result.data.qq;
                        wallet_wechat.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
                        [[WalletTableManager walletTable] addRecord: wallet_wechat];
                        
                        // create local wallet
                        CreatePocketViewController *vc = [[CreatePocketViewController alloc] init];
                        vc.createPocketViewControllerFromMode = CreatePocketViewControllerFromSocialMode;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }
            }];
            
            
            
        }
    }];
   
}

- (void)qqLoginBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    [[SocialManager socialManager] qqLoginRequest];
    [[SocialManager socialManager] setOnQQLoginSuccess:^(SocialModel *model) {
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        BOOL result = NO;
        for (Wallet *wallet in allLocalWallet) {
            if ([wallet.wallet_qq isEqualToString:model.openid]) {
                // 如果本地有当前账号对应的钱包
                [[NSUserDefaults standardUserDefaults] setObject:wallet.wallet_uid  forKey:Current_wallet_uid];
                [[NSUserDefaults standardUserDefaults] synchronize];
                result = YES;
                break;
            }
        }
        
        if (result) {
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
        }else{
            // 本地没有 wallet ,请求是否服务器绑定过钱包
            weakSelf.mainService.getUserInfoRequest.token = model.openid;
            weakSelf.mainService.getUserInfoRequest.type = @2;
            weakSelf.mainService.getUserInfoRequest.from = @"login";
            [weakSelf.mainService getUserInfo:^(UserInfoResult *result, BOOL isSuccess) {
                if (isSuccess) {
                    if (IsStrEmpty(result.data.uid)) {
                        // 无此用户
                        // bind phone => createPocket
                        BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
                        vc.model = model;
                        vc.model.socialModelType = SocialTypeQQ;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        // 有这个用户
                        Wallet *wallet_wechat = [[Wallet alloc] init];
                        wallet_wechat.wallet_uid = result.data.uid;
                        [[NSUserDefaults standardUserDefaults] setObject:wallet_wechat.wallet_uid  forKey:Current_wallet_uid];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        wallet_wechat.wallet_phone = result.data.phoneNum;
                        wallet_wechat.wallet_avatar = result.data.avatar;
                        wallet_wechat.wallet_img = result.data.avatar;
                        wallet_wechat.wallet_weixin = result.data.wechat;
                        wallet_wechat.wallet_qq = result.data.qq;
                        wallet_wechat.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
                        [[WalletTableManager walletTable] addRecord: wallet_wechat];
                        
                        // create local wallet
                        CreatePocketViewController *vc = [[CreatePocketViewController alloc] init];
                        vc.createPocketViewControllerFromMode = CreatePocketViewControllerFromSocialMode;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }
            }];
            
        }
    }];
}

- (void)privacyPolicyLabelDidTap{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)areaCodeBtnDidClick{
    CountryCodeAreaViewController *vc = [[CountryCodeAreaViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//CountryCodeAreaViewControllerDelegate
-(void)countryCodeAreaCellDidSelect:(AreaCodeModel *)model{
    self.areaCodeModel = model;
    self.loginView.areaCodeLabel.text = [NSString stringWithFormat:@"+%@", self.areaCodeModel.code];
}


// 开始倒计时
- (void)startCountDown{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.getVerifyCodeBtn setTitle:NSLocalizedString(@"获取验证码", nil)forState:UIControlStateNormal];
                self.loginView.getVerifyCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds;
            if (timeout == 60) {
                seconds = 60;
            }else{
                seconds = timeout % 60;
            }
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.getVerifyCodeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@%@", nil),strTime, NSLocalizedString(@"秒后重新发送", nil)] forState:UIControlStateNormal];
                self.loginView.getVerifyCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
