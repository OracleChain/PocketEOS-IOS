//
//  PhoneLoginViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "PhoneLoginMainView.h"
#import "CountryCodeAreaViewController.h"
#import "CreatePocketViewController.h"
#import "SocialManager.h"
#import "UserInfoResult.h"
#import "UserInfo.h"
#import "LoginService.h"
#import "AreaCodeModel.h"
#import "AuthResult.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "AddAccountViewController.h"

@interface PhoneLoginViewController ()<PhoneLoginMainViewDelegate, CountryCodeAreaViewControllerDelegate, UITextFieldDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PhoneLoginMainView *headerView;
@property(nonatomic, strong) LoginService *mainService;
@property(nonatomic , strong) AreaCodeModel *areaCodeModel;
@end

@implementation PhoneLoginViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"", nil)rightBtnTitleName:NSLocalizedString(@"", nil)delegate:self];
    }
    return _navView;
}

- (PhoneLoginMainView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneLoginMainView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.phoneTF.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _headerView;
}

- (LoginService *)mainService{
    if (!_mainService) {
        _mainService = [[LoginService alloc] init];
    }
    return _mainService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [LEETheme startTheme:SOCIAL_MODE];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
}


//PhoneLoginMainViewDelegate
- (void)getVerifyBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.headerView.phoneTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"手机号不能为空!", nil)];
        return;
    }
    
    [self startCountDown];
    self.mainService.getVerifyCodeRequest.phoneNum = self.headerView.phoneTF.text;
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
    
    if (IsStrEmpty(self.headerView.phoneTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"手机号不能为空!", nil)];
        return;
    }
    if (![RegularExpression validateVerifyCode:self.headerView.verifyCodeTF.text] ) {
        [TOASTVIEW showWithText: NSLocalizedString(@"验证码格式有误!", nil)];
        return;
    }
    WS(weakSelf);
    self.mainService.authVerifyCodeRequest.phoneNum = self.headerView.phoneTF.text;
    self.mainService.authVerifyCodeRequest.code = self.headerView.verifyCodeTF.text;
    NSString *phoneNum = self.headerView.phoneTF.text;
    
    [self.mainService authVerifyCode:^(AuthResult *result, BOOL isSuccess) {
        if (isSuccess) {
            
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message) ];
            if ([result.code isEqualToNumber:@0]) {
                [[NSUserDefaults standardUserDefaults] setObject: result.data.wallet_uid  forKey:Current_wallet_uid];
                [[NSUserDefaults standardUserDefaults] synchronize];
                /**
                 a. 1账号大于零个. 进首页
                 2账号等于零个,已经设置过密码 , 创建账号
                 b. 没有设置过密码, 创建钱包
                 */
                Wallet *wallet = CURRENT_WALLET;
                if (wallet && (wallet.wallet_shapwd.length > 6)) {
                    NSLog(@"%@", wallet.account_info_table_name);
                    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
                    if (accountArray.count > 0) {
                        // 如果本地有当前账号对应的钱包
                        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
                    }else{
                        AddAccountViewController *vc = [[AddAccountViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    // update wallet table
                    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET wallet_img = '%@' ,wallet_name = '%@' ,wallet_weixin = '%@'  ,wallet_qq = '%@'  ,wallet_phone = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , result.data.wallet_img, result.data.wallet_name, result.data.wallet_weixin, result.data.wallet_qq, result.data.wallet_phone, CURRENT_WALLET_UID];
                    NSLog(@"executeUpdate sql %@", sql);
                    [[WalletTableManager walletTable] executeUpdate:sql];
                    
                }else{
                    // 如果本地没有当前账号对应的钱包
                    if (![wallet.wallet_shapwd isEqualToString:DATABASE_NULLVALUE]) {
                        // 防止重复添加
                        Wallet *model = [[Wallet alloc] init];
                        if (phoneNum.length > 4) {
                            model.wallet_name = [phoneNum substringFromIndex:phoneNum.length - 4];
                        }else{
                            model.wallet_name = result.data.wallet_uid;
                        }
                        model.wallet_name = model.wallet_name;
                        model.wallet_uid = result.data.wallet_uid;
                        model.wallet_avatar = result.data.wallet_avatar;
                        model.wallet_weixin = result.data.wallet_weixin;
                        model.wallet_qq = result.data.wallet_qq;
                        model.wallet_phone = phoneNum;
                        model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
                        [[WalletTableManager walletTable] addRecord: model];
                    }
                    
                    // 创建钱包(本地数据库)
                    CreatePocketViewController *vc = [[CreatePocketViewController alloc] init];
                    vc.createPocketViewControllerFromMode = CreatePocketViewControllerFromSocialMode;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }
            }
        }
    }];
}

//UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.headerView.phoneTF) {
        return [WWJRegularJudge isMatchTelephoneFormat:self.headerView.phoneTF range:range string:string];
    }
    return YES;
}




- (void)areaCodeBtnDidClick{
    CountryCodeAreaViewController *vc = [[CountryCodeAreaViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


//CountryCodeAreaViewControllerDelegate
-(void)countryCodeAreaCellDidSelect:(AreaCodeModel *)model{
    self.areaCodeModel = model;
    self.headerView.areaCodeLabel.text = [NSString stringWithFormat:@"+%@", self.areaCodeModel.code];
}

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
                [self.headerView.getVerifyCodeBtn setTitle:NSLocalizedString(@"获取验证码", nil)forState:UIControlStateNormal];
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
                [self.headerView.getVerifyCodeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@%@", nil),strTime, NSLocalizedString(@"秒后重新发送", nil)] forState:UIControlStateNormal];
                self.headerView.getVerifyCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


@end
