//
//  PayRegistAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

typedef NS_ENUM(NSInteger, PaymentWay) {
    PaymentWayAlipay =1,
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
#import "GetAccountOrderStatusRequest.h"
#import "AccountOrderStatus.h"
#import "AccountOrderStatusResult.h"



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
@property(nonatomic , strong) GetAccountOrderStatusRequest *getAccountOrderStatusRequest;
@property(nonatomic , assign) BOOL willPay;
@property(nonatomic , copy) NSString *password;
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

- (GetAccountOrderStatusRequest *)getAccountOrderStatusRequest{
    if (!_getAccountOrderStatusRequest) {
        _getAccountOrderStatusRequest = [[GetAccountOrderStatusRequest alloc] init];
    }
    return _getAccountOrderStatusRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];

    [self requestResourceDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidFinish:) name:AlipayDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayDidFinish:) name:WechatPayDidFinishNotification object:nil];
    
    [self createAllKeys];
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

- (void)continuPayBtnDidClick{
    [self.view addSubview:self.paymentTipView];
    self.paymentTipView.payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f%@",self.createAccountResourceResult.data.cnyCost.floatValue / 100, NSLocalizedString(@"元", nil)];
    if (self.paymentWay == PaymentWayAlipay) {
        self.paymentTipView.alipayRightIconImageView.image = [UIImage imageNamed:@"circleWithRight_blue"];
        self.paymentTipView.wechatPayRightIconImageView.image = [UIImage imageNamed:@"circleWithoutRight_gray"];
    }else if (self.paymentWay == PaymentWayWechat){
        self.paymentTipView.alipayRightIconImageView.image = [UIImage imageNamed:@"circleWithoutRight_gray"];
        self.paymentTipView.wechatPayRightIconImageView.image = [UIImage imageNamed:@"circleWithRight_blue"];
    }
    
}


- (void)payCompletedBtnDidClick{
    // request order
    WS(weakSelf);
    self.getAccountOrderStatusRequest.accountName = self.headerView.accountNameTF.text;
    
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        self.getAccountOrderStatusRequest.uid = @"6f1a8e0eb24afb7ddc829f96f9f74e9d";
    }else{
        self.getAccountOrderStatusRequest.uid = CURRENT_WALLET_UID;
    }
    [self.getAccountOrderStatusRequest getDataSusscess:^(id DAO, id data) {
//        public static Integer statusUnGetMoney = 0;//为付款
//        public static Integer statusOk = 1;//创建成功
//        public static Integer statusWait = 2;//等待创建-已经收到宽
//        public static Integer statusDiscarded = 3;//
//        public static Integer statusCreateByOthers = 4;//被其他用户抢占
        AccountOrderStatusResult *result = [AccountOrderStatusResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            if ([result.data.createStatus isEqualToNumber:@1] || [result.data.createStatus isEqualToNumber:@2]) {
                [weakSelf storeAccountInfoToLocalDatabase];
            }else{
                [TOASTVIEW showWithText:result.data.message];
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)createBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.headerView.accountNameTF.text) ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请保证输入信息的完整~", nil)];
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
    self.willPay = YES;
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
    [self removeLoginPasswordView];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    self.password = self.loginPasswordView.inputPasswordTF.text;
    [self.view addSubview:self.paymentTipView];
    self.paymentWay = PaymentWayAlipay;
    self.paymentTipView.payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f%@",self.createAccountResourceResult.data.cnyCost.floatValue / 100, NSLocalizedString(@"元", nil)];
    
    [self removeLoginPasswordView];
}

//PaymentTipViewDelegate
- (void)backgroundViewDidClick{
    [self removePaymentTipView];
    [TOASTVIEW showWithText: NSLocalizedString(@"取消", nil)];
    [self.loginPasswordView removeFromSuperview];
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
    if (self.paymentWay == PaymentWayAlipay){
        // open alipay
        [self showTwoBtnView];
        [self doAPPay];
        [self removePaymentTipView];
    }else if (self.paymentWay == PaymentWayWechat){
        // open wechatPay
        [self showTwoBtnView];
        [self bizPay];
        [self removePaymentTipView];
    }
}

- (void)showTwoBtnView{
    self.headerView.confirmPayBtn.hidden = YES;
    self.headerView.twoBtnBaseView.hidden = NO;
}

- (void)bizPay {
    BOOL result = [WXApi isWXAppInstalled];
    if (result) {
        self.payRegistAccountService.createAccountOrderRequest.payChannel = @"0";//微信支付
        [ThirdPayManager sharedManager].thirdPayType = kWechatPay;
        [SVProgressHUD showWithStatus:nil];
        [self configCreateAccountOrderRequestParams];
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
        
    }else{
        [TOASTVIEW showWithText: NSLocalizedString(@"请先安装微信应用", nil)];
    }
}

- (void)doAPPay
{
    self.payRegistAccountService.createAccountOrderRequest.payChannel = @"1";//支付宝支付
    [ThirdPayManager sharedManager].thirdPayType = kAlipay;
    [SVProgressHUD showWithStatus:nil];
    [self configCreateAccountOrderRequestParams];
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

- (void)createAllKeys{
    self.ownerPrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    self.activePrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    NSLog(@"ownerPrivateKey:\n %@ \n ownerPublicKey:\n %@\n activePrivateKey:\n%@\n activePublicKey:\n %@\n", self.ownerPrivateKey.eosPrivateKey , self.ownerPrivateKey.eosPublicKey , self.activePrivateKey.eosPrivateKey, self.activePrivateKey.eosPublicKey);
}

- (void)configCreateAccountOrderRequestParams{

    self.payRegistAccountService.createAccountOrderRequest.accountName = self.headerView.accountNameTF.text;
    self.payRegistAccountService.createAccountOrderRequest.feeAmount = self.createAccountResourceResult.data.cnyCost.stringValue;
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        self.payRegistAccountService.createAccountOrderRequest.userId = @"6f1a8e0eb24afb7ddc829f96f9f74e9d";
    }else{
        self.payRegistAccountService.createAccountOrderRequest.userId = CURRENT_WALLET_UID;
    }
    
    if (self.headerView.privateKeyBeSameModeBtn.selected == YES) {
        self.payRegistAccountService.createAccountOrderRequest.ownerKey = self.ownerPrivateKey.eosPublicKey;
        self.payRegistAccountService.createAccountOrderRequest.activeKey = self.ownerPrivateKey.eosPublicKey;
    }else{
        self.payRegistAccountService.createAccountOrderRequest.ownerKey = self.ownerPrivateKey.eosPublicKey;
        self.payRegistAccountService.createAccountOrderRequest.activeKey = self.activePrivateKey.eosPublicKey;
    }
}

- (void)storeAccountInfoToLocalDatabase{
    
    // 本地数据库添加账号
    AccountInfo *model = [[AccountInfo alloc] init];
    model.account_name = self.headerView.accountNameTF.text;
    model.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
    
    if (self.headerView.privateKeyBeSameModeBtn.selected == YES) {
        model.account_owner_public_key = self.ownerPrivateKey.eosPublicKey;
        model.account_active_public_key = self.ownerPrivateKey.eosPublicKey;
        model.account_owner_private_key = [AESCrypt encrypt:self.ownerPrivateKey.eosPrivateKey password:self.password];
        model.account_active_private_key = [AESCrypt encrypt:self.ownerPrivateKey.eosPrivateKey password:self.password];
    }else{
        model.account_owner_public_key = self.ownerPrivateKey.eosPublicKey;
        model.account_active_public_key = self.activePrivateKey.eosPublicKey;
        model.account_owner_private_key = [AESCrypt encrypt:self.ownerPrivateKey.eosPrivateKey password:self.password];
        model.account_active_private_key = [AESCrypt encrypt:self.activePrivateKey.eosPrivateKey password:self.password];
    }
    
    
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
    WS(weakSelf);
    
    if (self.willPay) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"离开本页面将导致私钥丢失，由此造成的损失将由您自行承担!", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认离开", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"继续操作", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"继续操作");
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

  
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)removeLoginPasswordView{
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}

@end
