//
//  LoginEntranceViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "LoginEntranceViewController.h"
#import "LoginMainHeaderView.h"
#import "BBLoginViewController.h"
#import "PhoneLoginViewController.h"
#import "RtfBrowserViewController.h"
#import "CreatePocketViewController.h"
#import "SocialManager.h"
#import "LoginService.h"
#import "UserInfoResult.h"
#import "BindPhoneNumberViewController.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <SafariServices/SafariServices.h>
#import "AddAccountViewController.h"

@interface LoginEntranceViewController ()<LoginMainHeaderViewDelegate, SFSafariViewControllerDelegate>
@property(nonatomic, strong) LoginService *mainService;
@property(nonatomic , strong) LoginMainHeaderView *loginView;
@end

@implementation LoginEntranceViewController

- (LoginService *)mainService{
    if (!_mainService) {
        _mainService = [[LoginService alloc] init];
    }
    return _mainService;
}

- (LoginMainHeaderView *)loginView{
    if (!_loginView) {
        _loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginMainHeaderView" owner:nil options:nil] firstObject];
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


//LoginMainHeaderViewDelegate
- (void)changeToBlackBoxMode{
    BBLoginViewController *vc = [[BBLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginBtnDidClick:(UIButton *)sender{
    PhoneLoginViewController *vc = [[PhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wechatLoginBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    [[SocialManager socialManager] wechatLoginRequest];
    
    self.loginView.weChatLoginImage.hidden = YES;
    self.loginView.wechatLoggingIndicatorView.hidden = NO;
    self.loginView.wechatLoginLabel.text = NSLocalizedString(@"登录中...", nil);
    [[SocialManager socialManager] setOnWechatLoginSuccess:^(SocialModel *model) {
        weakSelf.mainService.getUserInfoRequest.token = model.unionid;
        weakSelf.mainService.getUserInfoRequest.type = @1;
        weakSelf.mainService.getUserInfoRequest.from = @"login";
        [weakSelf.mainService getUserInfo:^(UserInfoResult *result, BOOL isSuccess) {
            if (isSuccess) {
                if (IsStrEmpty(result.data.uid)) {
                    // server has not this user
                    // bind phone => createPocket
                    BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
                    vc.model = model;
                    vc.model.socialModelType = SocialTypeWechat;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    // server has this user
                    NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
                    BOOL selectResult = NO;
                    for (Wallet *wallet in allLocalWallet) {
                        if ([wallet.wallet_weixin isEqualToString:model.unionid]) {
                            [[NSUserDefaults standardUserDefaults] setObject:wallet.wallet_uid  forKey:Current_wallet_uid];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            selectResult = YES;
                            break;
                        }
                    }
                    if (selectResult) {
                        // local has this user
                        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
                    }else{
                        // local has not this user
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
                        AddAccountViewController *vc = [[AddAccountViewController alloc] init];
                        vc.addAccountViewControllerFromMode = AddAccountViewControllerFromLoginPage;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                }
            }else{
                [TOASTVIEW showWithText:@"网络错误"];
            }
        }];
    }];
    [[SocialManager socialManager] setOnWechatLoginFailed:^(BaseResp *resp) {
        weakSelf.loginView.weChatLoginImage.hidden = NO;
        weakSelf.loginView.wechatLoggingIndicatorView.hidden = YES;
        weakSelf.loginView.wechatLoginLabel.text = NSLocalizedString(@"微信登录", nil);
    }];
}

- (void)privacyPolicyLabelDidTap{
    if (@available(iOS 9.0, *)) {
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:3503",REQUEST_HTTP_STATIC_BASEURL ]] entersReaderIfAvailable:YES];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
            RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
            vc.rtfFileName = @"PocketEOSProtocol";
            [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
