//
//  BindPhoneNumberViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/4.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BindPhoneNumberViewController.h"
#import "CreatePocketViewController.h"
#import "GetVerifyCodeRequest.h"
#import "BindPhoneRequest.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "BindPhoneNumberHeaderView.h"
#import "NavigationView.h"
#import "RtfBrowserViewController.h"


@interface BindPhoneNumberViewController ()<UIGestureRecognizerDelegate, BindPhoneNumberHeaderViewDelegate, NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) BindPhoneNumberHeaderView *headerView;
@property(nonatomic , strong) GetVerifyCodeRequest *getVerifyCodeRequest;
@property(nonatomic , strong) BindPhoneRequest *bindPhoneRequest;
@end

@implementation BindPhoneNumberViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"绑定手机号" rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (BindPhoneNumberHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BindPhoneNumberHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 280);
    }
    return _headerView;
}
- (GetVerifyCodeRequest *)getVerifyCodeRequest{
    if (!_getVerifyCodeRequest) {
        _getVerifyCodeRequest = [[GetVerifyCodeRequest alloc] init];
    }
    return _getVerifyCodeRequest;
}

- (BindPhoneRequest *)bindPhoneRequest{
    if (!_bindPhoneRequest) {
        _bindPhoneRequest = [[BindPhoneRequest alloc] init];
    }
    return _bindPhoneRequest;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
}

//BindPhoneNumberHeaderViewDelegate
-(void)getVerifyCodeBtnDidClick:(UIButton *)sender{
    if (![RegularExpression validateMobile:self.headerView.phoneNumberTF.text] ) {
        [TOASTVIEW showWithText: @"手机号格式有误!" ];
        return;
    }
    [self startCountDown];
    self.getVerifyCodeRequest.phoneNum = self.headerView.phoneNumberTF.text;
    [self.getVerifyCodeRequest postDataSuccess:^(id DAO, id data) {
        [TOASTVIEW showWithText: VALIDATE_STRING(data[@"message"]) ];
        if ([data[@"code"] isEqualToValue:@0]) {
            // 发送短信成功
        }

    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
-(void)bindBtnDidClick:(UIButton *)sender{
    if (self.headerView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    if (![RegularExpression validateMobile:self.headerView.phoneNumberTF.text] ) {
        [TOASTVIEW showWithText: @"手机号格式有误!" ];
        return;
    }
    if (![RegularExpression validateVerifyCode:self.headerView.verifyCodeTF.text] ) {
        [TOASTVIEW showWithText: @"验证码格式有误!" ];
        return;
    }
    
    self.bindPhoneRequest.name = self.model.name;
    self.bindPhoneRequest.avatar = self.model.avatar;
    self.bindPhoneRequest.openid = self.model.openid;
    self.bindPhoneRequest.phoneNum = self.headerView.phoneNumberTF.text;
    self.bindPhoneRequest.type = self.model.type;
    self.bindPhoneRequest.code = self.headerView.verifyCodeTF.text;
    WS(weakSelf);
    [self.bindPhoneRequest postDataSuccess:^(id DAO, id data) {
        [TOASTVIEW showWithText: VALIDATE_STRING(data[@"message"]) ];
        NSNumber *code = data[@"code"];
        if ([code isEqualToNumber:@0]) {
            
            [[NSUserDefaults standardUserDefaults] setObject: VALIDATE_STRING(data[@"data"][@"uid"]) forKey:Current_wallet_uid];
            [[NSUserDefaults standardUserDefaults] synchronize];
            Wallet *wallet = CURRENT_WALLET;
            if (wallet) {
                NSLog(@"%@", wallet.account_info_table_name);
            }else{
                NSLog(@"没有 wallet");
                // 如果本地没有当前账号对应的钱包
                Wallet *wallet = [[Wallet alloc] init];
                wallet.wallet_name = weakSelf.model.name;
                wallet.wallet_img = weakSelf.model.avatar;
                
                if ([weakSelf.model.type isEqualToString:@"1"]) {
                    wallet.wallet_qq = weakSelf.model.openid;
                }else if ([weakSelf.model.type isEqualToString:@"2"]){
                    wallet.wallet_weixin = weakSelf.model.openid;
                }
                
                wallet.wallet_uid = CURRENT_WALLET_UID;
                wallet.wallet_phone = weakSelf.headerView.phoneNumberTF.text;
                wallet.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
                [[WalletTableManager walletTable] addRecord: wallet];
                CreatePocketViewController *vc=  [[CreatePocketViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
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
                [self.headerView.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.headerView.getVerifyCodeBtn.userInteractionEnabled = YES;
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
                [self.headerView.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                self.headerView.getVerifyCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
