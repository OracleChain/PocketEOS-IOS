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

@interface LoginMainViewController ()<UIGestureRecognizerDelegate, LoginViewDelegate>
@property(nonatomic, strong) LoginService *mainService;
@property(nonatomic , strong) LoginView *loginView;
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
    if (![RegularExpression validateMobile:self.loginView.phoneTF.text] ) {
        [TOASTVIEW showWithText: @"手机号格式有误!" ];
        return;
    }
    
    [self startCountDown];
    self.mainService.getVerifyCodeRequest.phoneNum = self.loginView.phoneTF.text;
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
    if (self.loginView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    
    if (![RegularExpression validateMobile:self.loginView.phoneTF.text] ) {
        [TOASTVIEW showWithText: @"手机号格式有误!" ];
        return;
    }
    if (![RegularExpression validateVerifyCode:self.loginView.verifyCodeTF.text] ) {
        [TOASTVIEW showWithText: @"验证码格式有误!" ];
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
                    // 如果本地有当前账号对应的钱包
                    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
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
    [[SocialManager socialManager] wechatLoginRequest];
    [[SocialManager socialManager] setOnWechatLoginSuccess:^(SocialModel *model) {
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        BOOL result = NO;
        for (Wallet *wallet in allLocalWallet) {
            if ([wallet.wallet_weixin isEqualToString:model.openid]) {
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
            // bind phone => createPocket
            BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
            vc.model = model;
            vc.model.type = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
   
}

- (void)qqLoginBtnDidClick:(UIButton *)sender{
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
            // bind phone => createPocket
            BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
            vc.model = model;
            vc.model.type = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
}

- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
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
                [self.loginView.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
                [self.loginView.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                self.loginView.getVerifyCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
