//
//  PayRegistAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

typedef NS_ENUM(NSInteger, PaymentWay) {
    PaymentWayNone = 0,
    PaymentWayAlipay ,
    PaymentWayWechat
};

#import "PayRegistAccountViewController.h"
#import "PayRegistAccountHeaderView.h"
#import "EosPrivateKey.h"
#import "BackupAccountViewController.h"
#import "CreateAccountRequest.h"
#import "PaymentTipView.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GetAccountRequest.h"
#import "GetAccount.h"
#import "GetAccountResult.h"
#import "PayRegistAccountService.h"
#import "CreateAccountResourceResult.h"
#import "CreateAccountResourceRespModel.h"
#import "WechatPayRespResult.h"
#import "WechatPayRespModel.h"
#import "AlipayRespResult.h"
#import "AlipayResultModel.h"


NSString * const AlipayDidFinishNotification = @"AlipayDidFinishNotification";
NSString * const WechatPayDidFinishNotification = @"WechatPayDidFinishNotification";


@interface PayRegistAccountViewController ()<PayRegistAccountHeaderViewDelegate, LoginPasswordViewDelegate, PaymentTipViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PayRegistAccountHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) PaymentTipView *paymentTipView;
@property(nonatomic , assign) PaymentWay paymentWay;
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@property(nonatomic , strong) PayRegistAccountService *payRegistAccountService;
@property(nonatomic , strong) EosPrivateKey *ownerPrivateKey;
@property(nonatomic , strong) EosPrivateKey *activePrivateKey;
@property(nonatomic , strong) CreateAccountResourceResult *createAccountResourceResult;
@end

@implementation PayRegistAccountViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"付费创建", nil)rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (PayRegistAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"PayRegistAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 460);
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

- (PaymentTipView *)paymentTipView{
    if (!_paymentTipView) {
        _paymentTipView = [[[NSBundle mainBundle] loadNibNamed:@"PaymentTipView" owner:nil options:nil] firstObject];
        _paymentTipView.frame = self.view.bounds;
        _paymentTipView.delegate = self;
    }
    return _paymentTipView;
}

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (PayRegistAccountService *)payRegistAccountService{
    if (!_payRegistAccountService) {
        _payRegistAccountService = [[PayRegistAccountService alloc] init];
    }
    return _payRegistAccountService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];

    [self requestResourceDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidFinish:) name:AlipayDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayDidFinish:) name:WechatPayDidFinishNotification object:nil];
}


- (void)requestResourceDetail{
    WS(weakSelf);
    [self.payRegistAccountService getCreateAccountResource:^(CreateAccountResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            
            [weakSelf.headerView updateViewWithResourceModel:result.data];
            weakSelf.createAccountResourceResult = result;
        }
    }];
}

//PayRegistAccountHeaderViewDelegate
- (void)privateKeyBeSameModeBtnDidClick:(UIButton *)sender{
    self.headerView.privateKeyBeSameModeBtn.selected = YES;
    self.headerView.privateKeyBeDiffrentModeBtn.selected = NO;
}

- (void)privateKeyBeDiffrentModeBtnDidClick:(UIButton *)sender{
    self.headerView.privateKeyBeSameModeBtn.selected = NO;
    self.headerView.privateKeyBeDiffrentModeBtn.selected = YES;
}


- (void)createBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.headerView.accountNameTF.text) ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"输入框不能为空!", nil)];
        return;
    }

    if (![ RegularExpression validateEosAccountName:self.headerView.accountNameTF.text ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"12位字符，只能由小写字母a~z和数字1~5组成。", nil)];
        return;
    }

    if (self.headerView.privateKeyBeSameModeBtn.isSelected == NO && self.headerView.privateKeyBeDiffrentModeBtn.selected == NO ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请选择私钥模式", nil)];
        return;
    }
    [self checkAccountExist];
}

- (void)checkAccountExist{
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(self.headerView.accountNameTF.text) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            if (model.account_name) {
                [TOASTVIEW showWithText: NSLocalizedString(@"账号已存在", nil)];
                return ;
            }else{
                [weakSelf.view addSubview:self.loginPasswordView];
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    [self.loginPasswordView removeFromSuperview];
    [self.view addSubview:self.paymentTipView];
    self.paymentTipView.payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f%@",self.createAccountResourceResult.data.cnyCost.floatValue / 100, NSLocalizedString(@"元", nil)];
}

//PaymentTipViewDelegate
- (void)backgroundViewDidClick{
    [self removePaymentTipView];
}

- (void)removePaymentTipView{
    [self.paymentTipView removeFromSuperview];
    self.paymentTipView = nil;
}

/**
 sender.tag = 1000 alipay
 sender.tag = 1001 wechatPay
 */
- (void)choosePaymentBtnDidClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        self.paymentWay = PaymentWayAlipay;
    }else if (sender.tag == 1001){
        self.paymentWay = PaymentWayWechat;
    }
}

- (void)confirmPayBtnDidClick:(UIButton *)sender{
    [self configCreateAccountOrderRequestParams];
    
    if (self.paymentWay == PaymentWayNone) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请选择付款方式", nil)];
    }else if (self.paymentWay == PaymentWayAlipay){
        // open alipay
        [self doAPPay];
        [self removePaymentTipView];
        
    }else if (self.paymentWay == PaymentWayWechat){
        // open wechatPay
        [self bizPay];
        [self removePaymentTipView];
    }
    
}

- (void)bizPay {
    self.payRegistAccountService.createAccountOrderRequest.payChannel = @"0";//微信支付
    [ThirdPayManager sharedManager].thirdPayType = kWechatPay;
    [SVProgressHUD showWithStatus:nil];
    [self.payRegistAccountService createAccountOrderByWechatPay:^(WechatPayRespResult *result, BOOL isSuccess) {
        if (isSuccess) {
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.partnerId = result.data.partnerId;
            req.prepayId = result.data.prepayId;
            req.nonceStr = result.data.nonceStr;
            req.timeStamp = result.data.timestamp.intValue;
            req.package = result.data.exPackage;
            req.sign = result.data.sign;
    
//            req.partnerId           = @"1509617931";
//            req.prepayId            = @"wx06115858391917fde79dcedc1461487879";
//            req.nonceStr            = @"34e6bfcd358e25ac1db0a4241b95651";
//            NSString *stampStr = @"1533797472";
//            req.timeStamp           = stampStr.intValue;
//            req.package             = @"Sign=WXPay";
//            req.sign                = @"F4624EF0D3F83189696BFE9E4B60339A";
            [WXApi sendReq:req];
        }
    }];
}

- (void)doAPPay
{
    self.payRegistAccountService.createAccountOrderRequest.payChannel = @"1";//支付宝支付
    [ThirdPayManager sharedManager].thirdPayType = kAlipay;
    [SVProgressHUD showWithStatus:nil];
    [self.payRegistAccountService createAccountOrderByAliPay:^(AlipayRespResult *result, BOOL isSuccess) {
        if (isSuccess) {
            NSString *orderString = result.data;
//
            // NOTE: 调用支付结果开始支付
            NSString *appScheme = @"PocketEos";
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    }];

}

- (void)configCreateAccountOrderRequestParams{
    self.ownerPrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    if (self.headerView.privateKeyBeSameModeBtn.selected == YES) {
        self.activePrivateKey = self.ownerPrivateKey;
    }else{
        self.activePrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    }
    
    NSLog(@"{ownerPrivateKey:%@\neosPublicKey:%@\nactivePrivateKey:%@\neosPublicKey:%@\n}", self.ownerPrivateKey.eosPrivateKey, self.ownerPrivateKey.eosPublicKey, self.activePrivateKey.eosPrivateKey, self.activePrivateKey.eosPublicKey);
    self.payRegistAccountService.createAccountOrderRequest.accountName = self.headerView.accountNameTF.text;
    self.payRegistAccountService.createAccountOrderRequest.feeAmount = self.createAccountResourceResult.data.cnyCost.stringValue;
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        self.payRegistAccountService.createAccountOrderRequest.userId = @"6f1a8e0eb24afb7ddc829f96f9f74e9d";
    }else{
        self.payRegistAccountService.createAccountOrderRequest.userId = CURRENT_WALLET_UID;
    }
    self.payRegistAccountService.createAccountOrderRequest.ownerKey = self.ownerPrivateKey.eosPublicKey;
    self.payRegistAccountService.createAccountOrderRequest.activeKey = self.activePrivateKey.eosPublicKey;
    
}

- (void)storeAccountInfoToLocalDatabase{
    
    // 本地数据库添加账号
    AccountInfo *model = [[AccountInfo alloc] init];
    model.account_name = self.headerView.accountNameTF.text;
    model.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
    model.account_active_public_key = self.activePrivateKey.eosPublicKey;
    model.account_owner_public_key = self.ownerPrivateKey.eosPublicKey;
    model.account_active_private_key = [AESCrypt encrypt:self.activePrivateKey.eosPrivateKey password:self.loginPasswordView.inputPasswordTF.text];
    model.account_owner_private_key = [AESCrypt encrypt:self.ownerPrivateKey.eosPrivateKey password:self.loginPasswordView.inputPasswordTF.text];
    model.is_privacy_policy = @"0";
    [[AccountsTableManager accountTable] addRecord: model];
    [WalletUtil setMainAccountWithAccountInfoModel:model];
    
    BackupAccountViewController *vc = [[BackupAccountViewController alloc] init];
    vc.accountName = self.headerView.accountNameTF.text ;
    [self.navigationController pushViewController:vc animated:YES];
    [self.loginPasswordView removeFromSuperview];
}

///--------------------
/// @name Notifications selector
///--------------------
- (void)alipayDidFinish:(NSNotification *)noti{
    NSLog(@"alipay noti.userInfo :: %@", noti.object);
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    AlipayResultModel *result = [AlipayResultModel mj_objectWithKeyValues:noti.object];
    if ([result.resultStatus isEqualToString:@"9000"]) {
        strMsg = @"支付结果：成功！";
        [self storeAccountInfoToLocalDatabase];
    }else{
        strMsg = [NSString stringWithFormat:@"支付结果：失败！resultStatus = %@, memo = %@", result.resultStatus,result.memo];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)wechatPayDidFinish:(NSNotification *)noti{
    NSLog(@"wechatPay noti.userInfo %@", noti.object);
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    PayResp *result = [PayResp mj_objectWithKeyValues:noti.object];
    switch (result.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            [self storeAccountInfoToLocalDatabase];
            break;
        case WXErrCodeCommon:
            strMsg = @"支付结果：普通错误类型";
            break;
        case WXErrCodeUserCancel:
            strMsg = @"支付结果：用户点击取消并返回";
            break;
        case WXErrCodeSentFail:
            strMsg = @"支付结果：发送失败";
            break;
        case WXErrCodeAuthDeny:
            strMsg = @"支付结果：授权失败";
            break;
        case WXErrCodeUnsupport:
            strMsg = @"支付结果：微信不支持";
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", result.errCode,result.errStr];
            
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
