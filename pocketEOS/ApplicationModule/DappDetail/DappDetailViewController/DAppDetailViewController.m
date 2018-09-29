//
//  DAppDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 09/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define JS_INTERACTION_METHOD_PUSH @"push"
#define JS_INTERACTION_METHOD_PUSHACTION @"pushAction"
#define JS_INTERACTION_METHOD_PUSHACTIONS @"pushActions"
#define JS_INTERACTION_METHOD_PUSHMESSAGE @"pushMessage"

#define JS_INTERACTION_METHOD_walletLanguage @"walletLanguage"
#define JS_INTERACTION_METHOD_getEosAccount @"getEosAccount"
#define JS_INTERACTION_METHOD_getWalletWithAccount @"getWalletWithAccount"
#define JS_INTERACTION_METHOD_getEosBalance @"getEosBalance"
#define JS_INTERACTION_METHOD_getEosAccountInfo @"getEosAccountInfo"
#define JS_INTERACTION_METHOD_getTransactionById @"getTransactionById"
#define JS_INTERACTION_METHOD_pushActions @"pushActions"
#define JS_INTERACTION_METHOD_pushTransfer @"pushTransfer"
#define JS_INTERACTION_METHOD_getAppInfo @"getAppInfo"
#define JS_INTERACTION_METHOD_unknown @"unknown"


#define JS_METHODNAME_CALLBACKRESULT @"callbackResult"
#define JS_METHODNAME_PUSHACTIONRESULT @"pushActionResult"

#import "DAppDetailViewController.h"
#import "WkDelegateController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TransferService.h"
#import "SelectAccountView.h"
#import "TransferAbi_json_to_bin_request.h"
#import "Abi_json_to_binRequest.h"
#import "DappTransferModel.h"
#import "DappTransferResult.h"
#import "DAppExcuteMutipleActionsBaseView.h"
#import "DappExcuteActionsDataSourceService.h"
#import "DAppExcuteMutipleActionsResult.h"
#import "ExcuteMultipleActionsService.h"
#import "DappPushMessageModel.h"
#import "DappDetailService.h"
#import "GetEosBalanceModel.h"
#import "GetTransactionByIdModel.h"

@interface DAppDetailViewController ()<UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler, WKDelegate , TransferServiceDelegate, LoginPasswordViewDelegate, SelectAccountViewDelegate, UIScrollViewDelegate, DAppExcuteMutipleActionsBaseViewDelegate, ExcuteMultipleActionsServiceDelegate>
@property WebViewJavascriptBridge* bridge;
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) TransferService *mainService;
@property(nonatomic, copy) NSString *WKScriptMessageName; // recieve WKScriptMessage.name
@property(nonatomic, strong) NSDictionary *WKScriptMessageBody;// recieve WKScriptMessage.body
@property(nonatomic, strong) SelectAccountView *selectAccountView;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic , strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property (nonatomic , strong) DappTransferResult *dappTransferResult;
@property(nonatomic , strong) DappTransferModel *dappTransferModel;
@property(nonatomic , strong) DAppExcuteMutipleActionsResult *dAppExcuteMutipleActionsResult;
@property(nonatomic , strong) DappPushMessageModel *dappPushMessageModel;
@property(nonatomic , strong) WKProcessPool *sharedProcessPool;
@property (nonatomic , strong) UIBarButtonItem *backItem;
@property (nonatomic , strong) UIBarButtonItem *closeItem;

@property(nonatomic , strong) DappExcuteActionsDataSourceService *dappExcuteActionsDataSourceService;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@property(nonatomic , strong) DappDetailService *dappDetailService;
@property(nonatomic , strong) DAppExcuteMutipleActionsBaseView *dAppExcuteMutipleActionsBaseView;
@property(nonatomic , assign) BOOL allowZoom;
@end

@implementation DAppDetailViewController

- (WKWebView *)webView{
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        
        self.userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = self.userContentController;
        
        self.sharedProcessPool = [[WKProcessPool alloc]init];
        configuration.processPool = self.sharedProcessPool;
        
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) configuration:configuration];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.delegate = self;
        
        // 顶部出现空白
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions

        }
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = @"PocketEosIos";
        } else {
            // Fallback on earlier versions
        }
        self.allowZoom = YES;
    }
    return _webView;
}

- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}

- (SelectAccountView *)selectAccountView{
    if (!_selectAccountView) {
        _selectAccountView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAccountView" owner:nil options:nil] firstObject];
        _selectAccountView.frame = self.view.bounds;
        _selectAccountView.delegate = self;
    }
    return _selectAccountView;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}


- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

- (Abi_json_to_binRequest *)abi_json_to_binRequest{
    if (!_abi_json_to_binRequest) {
        _abi_json_to_binRequest = [[Abi_json_to_binRequest alloc] init];
    }
    return _abi_json_to_binRequest;
}

-(UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        btn.lee_theme
        .LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x000000), UIControlStateNormal)
        .LeeAddButtonTitleColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF), UIControlStateNormal);
        [btn setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        //左对齐
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        btn.frame = CGRectMake(0, -40, 50, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

-(UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme
        .LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x000000), UIControlStateNormal)
        .LeeAddButtonTitleColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF), UIControlStateNormal);
        [btn setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        btn.frame = CGRectMake(0, 0, 50, 40);
        _closeItem.customView = btn;
    }
    return _closeItem;
}


- (DAppExcuteMutipleActionsBaseView *)dAppExcuteMutipleActionsBaseView{
    if (!_dAppExcuteMutipleActionsBaseView) {
        _dAppExcuteMutipleActionsBaseView = [[DAppExcuteMutipleActionsBaseView alloc] init];
        _dAppExcuteMutipleActionsBaseView.frame = CGRectMake(0, SCREEN_HEIGHT-380, SCREEN_WIDTH, 380 );
        _dAppExcuteMutipleActionsBaseView.delegate = self;
    }
    return _dAppExcuteMutipleActionsBaseView;
}

- (DappExcuteActionsDataSourceService *)dappExcuteActionsDataSourceService{
    if (!_dappExcuteActionsDataSourceService) {
        _dappExcuteActionsDataSourceService = [[DappExcuteActionsDataSourceService alloc] init];
    }
    return _dappExcuteActionsDataSourceService;
}

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}

- (DappDetailService *)dappDetailService{
    if (!_dappDetailService) {
        _dappDetailService = [[DappDetailService alloc] init];
        _dappDetailService.choosedAccountName = self.choosedAccountName;
    }
    return _dappDetailService;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHACTION];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSH];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHACTIONS];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHMESSAGE];
    
    
    if (IsStrEmpty(self.webView.title)) {
        [self.webView reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushAction('%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushActions('%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"push('%@','%@','%@','%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushMessage('%@','%@','%@')"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"DAppDidClick" label: VALIDATE_STRING(self.model.applyName)];
    
    // 解决顶部出现空白
    self.automaticallyAdjustsScrollViewInsets=NO;//自动滚动调整，默认为YES
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    self.title = self.model.applyName;
    if (IsStrEmpty(self.choosedAccountName)) {
        [self.view addSubview:self.selectAccountView];
    }else{
        [self loadWebView];
    }
    self.navigationItem.leftBarButtonItems =@[self.backItem , self.closeItem];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.allowZoom = NO;
    [self passEosAccountNameToJS];
    [self passWalletInfoToJS];
    WS(weakSelf);
    // 确保js 能收到 eosAccountName
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
    
}


//DAppExcuteMutipleActionsBaseViewDelegate
- (void)excuteMutipleActionsConfirmBtnDidClick{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.dAppExcuteMutipleActionsBaseView.passwordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
            [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:Password is invalid. Please check it."] mj_JSONString]];
        }else{
            [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:@"ERROR:Password is invalid. Please check it."];
            
        }
        return;
    }
    [self pushActions];
}

- (void)excuteMutipleActionsCloseBtnDidClick{
    [self.dAppExcuteMutipleActionsBaseView removeFromSuperview];
    self.dAppExcuteMutipleActionsBaseView = nil;
    
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:CANCLE"] mj_JSONString]];
    }else{
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:@"ERROR:CANCLE"];
        
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil)style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [TOASTVIEW showWithText: [ error localizedDescription]];
}



-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    self.WKScriptMessageName = (NSString *)message.name;
    self.WKScriptMessageBody = (NSDictionary *)message.body;
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTION] || [self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSH]) {
        self.dappTransferResult = [DappTransferResult mj_objectWithKeyValues:self.WKScriptMessageBody];
        self.dappTransferModel = (DappTransferModel *)[DappTransferModel mj_objectWithKeyValues:[self.dappTransferResult.message mj_JSONObject ] ];
        [self.view addSubview:self.loginPasswordView];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTIONS]){
        self.dAppExcuteMutipleActionsResult = [DAppExcuteMutipleActionsResult mj_objectWithKeyValues:self.WKScriptMessageBody];
        [self buildExcuteActionsDataSource];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]){
        self.dappPushMessageModel = [DappPushMessageModel mj_objectWithKeyValues:self.WKScriptMessageBody];
            
        if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosAccount]) {
            [self js_pushMessage_method_getEosAccount];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getAppInfo]){
            [self js_pushMessage_method_getAppInfo];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_walletLanguage]){
            [self js_pushMessage_method_walletLanguage];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getWalletWithAccount]){
            [self js_pushMessage_method_getWalletWithAccount];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosBalance]){
            [self js_pushMessage_method_getEosBalance];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosAccountInfo]){
            [self js_pushMessage_method_getEosAccountInfo];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getTransactionById]){
            [self js_pushMessage_method_getTransactionById];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_pushActions]){
            [self js_pushMessage_method_pushActions];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_pushTransfer]){
            [self js_pushMessage_method_pushTransfer];
        }
        
    }
}

- (void)buildExcuteActionsDataSource{
    WS(weakSelf);
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        self.dappExcuteActionsDataSourceService.actionsResultDict = self.dappPushMessageModel.params;
    }else if([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTIONS]){
        self.dappExcuteActionsDataSourceService.actionsResultDict = self.dAppExcuteMutipleActionsResult.actionsDetails;
    }
    
    [self.dappExcuteActionsDataSourceService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.view addSubview:weakSelf.dAppExcuteMutipleActionsBaseView];
            [weakSelf.dAppExcuteMutipleActionsBaseView updateViewWithArray:weakSelf.dappExcuteActionsDataSourceService.dataSourceArray];
        }
    }];
    
}


// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self removeLoginPasswordView];
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:CANCLE"] mj_JSONString]];
    }else{
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:@"ERROR:CANCLE"];
        
    }
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
            [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:Password is invalid. Please check it."] mj_JSONString]];
        }else{
            [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:@"ERROR:Password is invalid. Please check it."];
        }
        return;
    }
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSH]) {
        [self push];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTION]){
        [self pushAction];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTIONS]){
        [self pushActions];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]){
        [self pushAction];
    }
}

- (void)push{
    self.abi_json_to_binRequest.code = self.dappTransferResult.contract;
    self.mainService.code = self.dappTransferResult.contract;
    self.abi_json_to_binRequest.action = self.dappTransferResult.action;
    self.mainService.action = self.dappTransferResult.action;
    self.abi_json_to_binRequest.args = [self.dappTransferResult.message mj_JSONObject];
    
    WS(weakSelf);
    [self.abi_json_to_binRequest postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        //        if (![data[@"code"] isEqualToNumber:@0]) {
        //            [weakSelf feedbackToJsWithSerialNumber:weakSelf.dappTransferModel.serialNumber andMessage:data[@"data"]];
        //            return ;
        //        }
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.choosedAccountName];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.mainService.sender = weakSelf.choosedAccountName;
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf removeLoginPasswordView];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

// adapt old version
- (void)pushAction{
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.code = self.dappTransferModel.contract;
    self.transferAbi_json_to_bin_request.quantity = self.dappTransferModel.quantity;
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = self.dappTransferModel.from;
    self.transferAbi_json_to_bin_request.to = self.dappTransferModel.to;
    self.transferAbi_json_to_bin_request.memo = self.dappTransferModel.memo;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        
        //        if (![data[@"code"] isEqualToNumber:@0]) {
        //            [weakSelf feedbackToJsWithSerialNumber:weakSelf.dappTransferModel.serialNumber andMessage:data[@"data"]];
        //            return ;
        //        }
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.choosedAccountName];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.mainService.action = ContractAction_TRANSFER;
        weakSelf.mainService.sender = weakSelf.choosedAccountName;
        weakSelf.mainService.code = weakSelf.dappTransferModel.contract;
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf removeLoginPasswordView];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)pushActions{
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
    if (accountInfo) {
        [self.excuteMultipleActionsService excuteMultipleActionsWithSender:accountInfo.account_name andExcuteActionsArray:self.dappExcuteActionsDataSourceService.dataSourceArray andAvailable_keysArray:@[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)] andPassword: self.dAppExcuteMutipleActionsBaseView.passwordTF.text];//self.loginPasswordView.inputPasswordTF.text
    }else{
        [TOASTVIEW showWithText: NSLocalizedString(@"您钱包中暂无操作账号~", nil)];
    }
   [self removeLoginPasswordView];
}

// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"交易成功!", nil)];
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:VALIDATE_STRING(result.transaction_id)];
        
        
    }else{
        [TOASTVIEW showWithText: result.message];
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:[NSString stringWithFormat:@"ERROR:%@", result.message]];
    }
    
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:VALIDATE_STRING([[self handlePushActionResultWithTransactionResult:result andSerialNumber:self.dappPushMessageModel.serialNumber] mj_JSONString])];
    }
}

//ExcuteMultipleActionsServiceDelegate
- (void)excuteMultipleActionsDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"签名成功", nil)];
        [self.dAppExcuteMutipleActionsBaseView removeFromSuperview];
        self.dAppExcuteMutipleActionsBaseView = nil;
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:VALIDATE_STRING(result.transaction_id)];
    }else{
        [TOASTVIEW showWithText: result.message];
        
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:[NSString stringWithFormat:@"ERROR:%@", result.message]];
    }
    [self removeLoginPasswordView];
    [SVProgressHUD dismiss];
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:VALIDATE_STRING([[self handlePushActionResultWithTransactionResult:result andSerialNumber:self.dappPushMessageModel.serialNumber] mj_JSONString])];
    }
}

- (NSMutableDictionary *)handlePushActionResultWithTransactionResult:(TransactionResult *)result andSerialNumber:(NSString *)serialNumber{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if ([result.code isEqualToNumber:@0]) {
        [dataDict setValue: VALIDATE_STRING(self.dappPushMessageModel.serialNumber) forKey:@"serialNumber"];
        [dataDict setValue: VALIDATE_STRING(result.transaction_id) forKey:@"txid"];
        if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
            [dataDict setValue: VALIDATE_STRING(self.excuteMultipleActionsService.ref_block_num) forKey:@"block_num"];
        }else{
            [dataDict setValue: VALIDATE_STRING(self.mainService.ref_block_num) forKey:@"block_num"];
        }
        [resultDict setValue:VALIDATE_NUMBER(result.code) forKey:@"code"];
        [resultDict setValue:VALIDATE_STRING(result.message) forKey:@"message"];
        [resultDict setValue:dataDict forKey:@"data"];
    }else{
        [dataDict setValue: VALIDATE_STRING(result.message) forKey:@"errorMsg"];
        [dataDict setValue: VALIDATE_STRING(self.dappPushMessageModel.serialNumber) forKey:@"serialNumber"];
        [resultDict setValue:VALIDATE_NUMBER(result.code) forKey:@"code"];
        [resultDict setValue:VALIDATE_STRING(result.message) forKey:@"message"];
        [resultDict setValue:dataDict forKey:@"data"];

    }
    return resultDict;
}

- (NSMutableDictionary *)handleResponseToJsErrorInfoWithErrorMessage:(NSString *)errorMessage{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue: VALIDATE_STRING(self.dappPushMessageModel.serialNumber) forKey:@"serialNumber"];
    [dataDict setValue: VALIDATE_STRING(errorMessage) forKey:@"errorMsg"];
    [resultDict setValue:VALIDATE_NUMBER(@1) forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(errorMessage) forKey:@"message"];
    [resultDict setValue:dataDict forKey:@"data"];
    return resultDict;
}

// pushMessageResultResponse callbackResult
- (void)responseToJsWithJSMethodName:(NSString *)jsMethodName SerialNumber:(NSString *)serialNumber andMessage:(NSString *)message{
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@', '%@')", jsMethodName,serialNumber, message];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)passEosAccountNameToJS{
    NSString *js = [NSString stringWithFormat:@"getEosAccount('%@')", self.choosedAccountName];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
        
    }];
}

- (void)passWalletInfoToJS{
    Wallet *wallet = CURRENT_WALLET;
    NSMutableDictionary *walletDict = [[NSMutableDictionary alloc] init];
    [walletDict setValue:self.choosedAccountName forKey:@"account"];
    [walletDict setValue:wallet.wallet_uid forKey:@"uid"];
    [walletDict setValue:wallet.wallet_name forKey:@"wallet_name"];
    [walletDict setValue:wallet.wallet_avatar forKey:@"image"];
    NSString *js = [NSString stringWithFormat:@"getWalletWithAccount('%@')",[walletDict mj_JSONString]];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
    }];
}

// JS_INTERACTION_METHOD_PUSHMESSAGE_method
- (void)js_pushMessage_method_getAppInfo{
    WS(weakSelf);
    [self.dappDetailService getAppInfo:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_walletLanguage{
    WS(weakSelf);
    [self.dappDetailService walletLanguage:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_getEosAccount{
    WS(weakSelf);
    [self.dappDetailService getEosAccount:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_getWalletWithAccount{
    WS(weakSelf);
    [self.dappDetailService getWalletWithAccount:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_getEosBalance{
    WS(weakSelf);
    GetEosBalanceModel *model = [GetEosBalanceModel mj_objectWithKeyValues:self.dappPushMessageModel.params];
    self.dappDetailService.code = model.contract;
    self.dappDetailService.scope = model.account;
    self.dappDetailService.table = @"accounts";
    
    [self.dappDetailService getEosBalance:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_getEosAccountInfo{
    WS(weakSelf);
    [self.dappDetailService getEosAccountInfo:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_getTransactionById{
    WS(weakSelf);
    GetTransactionByIdModel *model = [GetTransactionByIdModel mj_objectWithKeyValues:self.dappPushMessageModel.params];
    self.dappDetailService.transactionIdStr = model.txid;
    [self.dappDetailService getTransactionById:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_pushActions{
    self.dAppExcuteMutipleActionsResult = [DAppExcuteMutipleActionsResult mj_objectWithKeyValues:[self.dappPushMessageModel.params mj_JSONObject]];
    [self buildExcuteActionsDataSource];
}

- (void)js_pushMessage_method_pushTransfer{
    self.dappTransferModel = (DappTransferModel *)[DappTransferModel mj_objectWithKeyValues: [self.dappPushMessageModel.params mj_JSONObject] ];
    [self.view addSubview:self.loginPasswordView];
}

- (void)js_pushMessage_method_unknown{
    WS(weakSelf);
    [self.dappDetailService unknownMethod:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}




//SelectAccountViewDelegate
- (void)selectAccountBtnDidClick:(UIButton *)sender{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = UIColor.redColor;
    WS(weakSelf);
    
    NSArray *accountNameArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
    if (accountNameArr.count == 0) {
        [TOASTVIEW showWithText:NSLocalizedString(@"暂无账号!", nil)];
        return;
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:[[AccountsTableManager accountTable] selectAllNativeAccountName] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.selectAccountView.accountChooseLabel.text = [NSString stringWithFormat:@"%@" , strings[0]];
        weakSelf.choosedAccountName = VALIDATE_STRING(strings[0]);
    }cancel:^{
        [weakSelf.selectAccountView removeFromSuperview];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)understandBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.choosedAccountName)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请选择您将选择的账号!", nil)];
        return;
    } else{
        [self.selectAccountView removeFromSuperview];
        [self loadWebView];
    }
}

- (void)loadWebView{
    NSString *requestStr;
//    self.model.url = @"http://oct.xpet.io/index.html?identity=684";//%@?identity=684&language=Chinese
//    self.model.url = @"https://dice.eosbet.io/?ref=jintianyaook";
//    if ([NSBundle isChineseLanguage]) {
//        requestStr = [NSString stringWithFormat:@"%@?language=Chinese",self.model.url];
//    }else{
//        requestStr = [NSString stringWithFormat:@"%@?language=English",self.model.url];
//    }
    requestStr = [NSString stringWithFormat:@"%@",self.model.url];
    NSURLRequest *finalRequest = [NSURLRequest requestWithURL:String_To_URL(requestStr)];
    [self.webView loadRequest: finalRequest];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
}

-(void)backgroundViewDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backNative {
    if([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }else{
        [self closeNative];
    }
}

- (void)closeNative {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}


@end

