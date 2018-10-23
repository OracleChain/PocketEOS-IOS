//
//  ScatterMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/17.
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


#import "ScatterMainViewController.h"
#import "SelectAccountView.h"
#import "WkDelegateController.h"
#import "ScatterResult_type_identityFromPermissions.h"
#import "ScatterResult_type_requestSignature.h"
#import "ExcuteMultipleActionsService.h"
#import "DappExcuteActionsDataSourceService.h"
#import "DAppExcuteMutipleActionsBaseView.h"
#import "Abi_bin_to_jsonRequest.h"
#import "Abi_bin_to_json_Result.h"
#import "Abi_bin_to_json.h"


@interface ScatterMainViewController ()<UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler, WKDelegate, SelectAccountViewDelegate, DAppExcuteMutipleActionsBaseViewDelegate, WKURLSchemeHandler>
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic , strong) WKProcessPool *sharedProcessPool;
@property (nonatomic , strong) UIBarButtonItem *backItem;
@property (nonatomic , strong) UIBarButtonItem *closeItem;
@property(nonatomic, strong) SelectAccountView *selectAccountView;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@property(nonatomic , strong) DappExcuteActionsDataSourceService *dappExcuteActionsDataSourceService;
@property(nonatomic , strong) ScatterResult_type_requestSignature *requestSignature_scatterResult;
@property(nonatomic , strong) DAppExcuteMutipleActionsBaseView *dAppExcuteMutipleActionsBaseView;
@property(nonatomic , strong) NSMutableArray *finalExcuteActionsArray; // excuteActions add binargs Array
@property(nonatomic , assign) NSInteger abi_bin_to_json_request_count;
@property(nonatomic , strong) Abi_bin_to_jsonRequest *abi_bin_to_jsonRequest;
@end

@implementation ScatterMainViewController



- (WKWebView *)webView{
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        
        self.userContentController =[[WKUserContentController alloc]init];
        
        WKUserScript *script = [[WKUserScript alloc] initWithSource:[self getInjectJS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.userContentController addUserScript:script];
        
        
        configuration.userContentController = self.userContentController;
        
        
        self.sharedProcessPool = [[WKProcessPool alloc]init];
        configuration.processPool = self.sharedProcessPool;
        
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) configuration:configuration];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        
        // 顶部出现空白
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            
        }
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = @"PocketEosIos"; //tokenpocket
        } else {
            // Fallback on earlier versions
        }
    }
    return _webView;
}

- (SelectAccountView *)selectAccountView{
    if (!_selectAccountView) {
        _selectAccountView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAccountView" owner:nil options:nil] firstObject];
        _selectAccountView.frame = self.view.bounds;
        _selectAccountView.delegate = self;
    }
    return _selectAccountView;
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

- (DappExcuteActionsDataSourceService *)dappExcuteActionsDataSourceService{
    if (!_dappExcuteActionsDataSourceService) {
        _dappExcuteActionsDataSourceService = [[DappExcuteActionsDataSourceService alloc] init];
    }
    return _dappExcuteActionsDataSourceService;
}

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
//        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}


- (DAppExcuteMutipleActionsBaseView *)dAppExcuteMutipleActionsBaseView{
    if (!_dAppExcuteMutipleActionsBaseView) {
        _dAppExcuteMutipleActionsBaseView = [[DAppExcuteMutipleActionsBaseView alloc] init];
        _dAppExcuteMutipleActionsBaseView.frame = CGRectMake(0, SCREEN_HEIGHT-380, SCREEN_WIDTH, 380 );
        _dAppExcuteMutipleActionsBaseView.delegate = self;
    }
    return _dAppExcuteMutipleActionsBaseView;
}

- (Abi_bin_to_jsonRequest *)abi_bin_to_jsonRequest{
    if (!_abi_bin_to_jsonRequest) {
        _abi_bin_to_jsonRequest = [[Abi_bin_to_jsonRequest alloc] init];
    }
    return _abi_bin_to_jsonRequest;
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
    self.navigationItem.leftBarButtonItems =@[self.backItem , self.closeItem];
    
    [self.view addSubview: self.selectAccountView];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    NSLog(@"ReceiveMessage: %@", message);
    NSString *recivedMessage = message;
    NSString *handledMessage =  [recivedMessage stringByReplacingOccurrencesOfString:@"42/scatter," withString:@""];
    NSArray *result = [handledMessage mj_JSONObject];
    NSString *result1_tojsonStr = [result[1] mj_JSONString];
    NSString *responseStr;
    if ([result[0] containsString:@"pair"]) {
        NSString *test = @"42/scatter,[\"paired\",true]";

    }else if ([result[0] containsString:@"api"]){
        if ([result1_tojsonStr containsString:@"identityFromPermissions"] || [result1_tojsonStr containsString:@"authenticate"]
            || [result1_tojsonStr containsString:@"getOrRequestIdentity"] || [result1_tojsonStr containsString:@"requestAddNetwork"]) {
            ScatterResult_type_identityFromPermissions *scatterResult = [ScatterResult_type_identityFromPermissions mj_objectWithKeyValues:result[1]];

            AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];

            NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
            [resultDict setObject:[scatterResult.scatterResult_appkey sha256] forKey:@"hash"];
            [resultDict setObject:VALIDATE_STRING(accountInfo.account_active_public_key)  forKey:@"publicKey"];
            [resultDict setObject:@"PocketEOS" forKey:@"name"];
            [resultDict setObject: [NSNumber numberWithBool:NO] forKey:@"kyc"];

            NSMutableDictionary *accountDict = [NSMutableDictionary dictionary];
            [accountDict setObject:VALIDATE_STRING(self.choosedAccountName) forKey:@"name"];
            [accountDict setObject:@"active" forKey:@"authority"];
            [accountDict setObject:VALIDATE_STRING(accountInfo.account_active_public_key) forKey:@"publicKey"];
            [accountDict setObject:@"eos" forKey:@"blockchain"];

            [resultDict setObject:@[accountDict] forKey:@"accounts"];

            [finalDict setObject:resultDict forKey:@"result"];
            [finalDict setObject:scatterResult.scatterResult_id forKey:@"id"];

            NSArray *finalArr = @[@"api", finalDict];
            responseStr = [NSString stringWithFormat:@"42/scatter,%@", [finalArr mj_JSONString]];



        }else if ([result1_tojsonStr containsString:@"requestSignature"]){
            self.requestSignature_scatterResult = [ScatterResult_type_requestSignature mj_objectWithKeyValues:result[1]];
            [self buildDataSource];

        }

        NSLog(@"responseStr: %@", responseStr);
    }
}

- (void)buildDataSource{
    WS(weakSelf);
    self.finalExcuteActionsArray = [NSMutableArray array];
    self.abi_bin_to_json_request_count = 0;
    NSMutableArray *tmp = [NSMutableArray array];
    NSArray *actionsArray = self.requestSignature_scatterResult.actions;
    for (int i = 0 ; i < actionsArray.count; i++) {
        NSDictionary *dict = actionsArray[i];
        ExcuteActions *action = [ExcuteActions mj_objectWithKeyValues:dict];
        action.tag = [NSString stringWithFormat:@"action%d", i];
        
        self.abi_bin_to_jsonRequest.code = action.account;
        self.abi_bin_to_jsonRequest.action = action.name;
        self.abi_bin_to_jsonRequest.binargs = dict[@"data"];
        
        AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] init];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Accept"];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
        outerNetworkingManager.requestSerializer=[AFJSONRequestSerializer serializer];
        [outerNetworkingManager.requestSerializer setValue: action.tag forHTTPHeaderField: @"From"];
        
        [outerNetworkingManager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript", nil]];
        NSString *url = @"http://api.pocketeos.top/api_oc_blockchain-v1.3.0/abi_bin_to_json";
        //        NSString *url = @"http://10.0.0.11:8080/lottery/abi_json_to_bin";
        [outerNetworkingManager POST: url parameters: [self.abi_bin_to_jsonRequest parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *HTTPHeaderFieldFromValue = [outerNetworkingManager.requestSerializer valueForHTTPHeaderField:@"From"];
            NSLog(@"responseObject: %@,HTTPHeaderFieldFromValue: %@", responseObject, HTTPHeaderFieldFromValue);
            Abi_bin_to_json_Result *abi_bin_to_json_result = [Abi_bin_to_json_Result mj_objectWithKeyValues:responseObject];
            
            if ([abi_bin_to_json_result.code isEqualToNumber:@0]) {
                if ([HTTPHeaderFieldFromValue isEqualToString:action.tag]) {
                    action.data = abi_bin_to_json_result.data.args;
                    weakSelf.abi_bin_to_json_request_count ++;
                    [tmp addObject:action];
                    
                    if (weakSelf.abi_bin_to_json_request_count == actionsArray.count) {
                        weakSelf.finalExcuteActionsArray =  (NSMutableArray *)[tmp sortedArrayUsingComparator:^NSComparisonResult(ExcuteActions  *obj1, ExcuteActions *obj2) {
                            return [obj1.tag compare:obj2.tag options:(NSCaseInsensitiveSearch)];
                        }];
                        
                        [weakSelf buildExcuteActionsDataSource];
                    }
                }
            }else{
                NSLog(@"%@",abi_bin_to_json_result.message );
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
    
    
}


- (void)buildExcuteActionsDataSource{
    WS(weakSelf);
    NSMutableArray *actionsArr = [NSMutableArray array];
    for (int i = 0 ; i < self.finalExcuteActionsArray.count; i++) {
        ExcuteActions *action = self.finalExcuteActionsArray[i];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
        [actionDict setObject:VALIDATE_STRING(action.account) forKey:@"account"];
        [actionDict setObject:VALIDATE_STRING(action.name) forKey:@"name"];
        [actionDict setObject:IsNilOrNull(action.data) ? @{} : action.data forKey:@"data"];
        [actionDict setObject:IsNilOrNull(action.authorization) ? @[] : action.authorization forKey:@"authorization"];
        [actionsArr addObject:actionDict];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Scatter_ExcuteActions" forKey:@"type"];
    [dict setObject:VALIDATE_ARRAY(actionsArr) forKey:@"actions"];
    
    self.dappExcuteActionsDataSourceService.actionsResultDict = [dict mj_JSONString];
    [self.dappExcuteActionsDataSourceService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.view addSubview:weakSelf.dAppExcuteMutipleActionsBaseView];
            [weakSelf.dAppExcuteMutipleActionsBaseView updateViewWithArray:weakSelf.dappExcuteActionsDataSourceService.dataSourceArray];
        }
    }];
    
}


//DAppExcuteMutipleActionsBaseViewDelegate
- (void)excuteMutipleActionsConfirmBtnDidClick{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
//    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.dAppExcuteMutipleActionsBaseView.passwordTF.text]) {
//        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
//        return;
//    }
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
//    NSString *signatureStr = [self.excuteMultipleActionsService excuteMultipleActionsForScatterWithScatterResult:self.requestSignature_scatterResult andAvailable_keysArray:@[VALIDATE_STRING(accountInfo.account_active_public_key), VALIDATE_STRING(accountInfo.account_owner_public_key) ] andPassword:self.dAppExcuteMutipleActionsBaseView.passwordTF.text];
    
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
//    [resultDict setObject:@[signatureStr] forKey:@"signatures"];
    [resultDict setObject:[NSDictionary dictionary] forKey:@"returnedFields"];
    
    [finalDict setObject:resultDict forKey:@"result"];
    [finalDict setObject:self.requestSignature_scatterResult.scatterResult_id forKey:@"id"];
    
    NSArray *finalArr = @[@"api", finalDict];
    NSString *responseStr;
    responseStr = [NSString stringWithFormat:@"42/scatter,%@", [finalArr mj_JSONString]];
    
    
    NSLog(@"responseStr: %@", responseStr);
    [self removeExcuteMutipleActionsBaseView];
}

- (void)notifyScatter_js_user_cancled{
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setObject:@"signature_rejected" forKey:@"type"];
    [resultDict setObject:@"User rejected the signature request" forKey:@"message"];
    [resultDict setObject:@402 forKey:@"code"];
    [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"isError"];
    
    [finalDict setObject:resultDict forKey:@"result"];
    [finalDict setObject:VALIDATE_STRING(self.requestSignature_scatterResult.scatterResult_id)  forKey:@"id"];
    
    NSArray *finalArr = @[@"api", finalDict];
    NSString *responseStr;
    responseStr = [NSString stringWithFormat:@"42/scatter,%@", [finalArr mj_JSONString]];
    
    
    NSLog(@"responseStr: %@", responseStr);
}


// pushMessageResultResponse callbackResult
- (void)responseToJsWithJSMethodName:(NSString *)jsMethodName SerialNumber:(NSString *)serialNumber andMessage:(NSString *)message{
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@', '%@')", jsMethodName,serialNumber, message];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}


- (void)excuteMutipleActionsCloseBtnDidClick{
    [self removeExcuteMutipleActionsBaseView];
    [self notifyScatter_js_user_cancled];
}

- (void)removeExcuteMutipleActionsBaseView{
    [self.dAppExcuteMutipleActionsBaseView removeFromSuperview];
    self.dAppExcuteMutipleActionsBaseView = nil;
}


#pragma mark -- WKWebViewDelegate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
    NSLog(@"reload");
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [TOASTVIEW showWithText: [error localizedDescription]];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//SelectAccountViewDelegate
- (void)selectAccountBtnDidClick:(UIButton *)sender{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.cancelText = NSLocalizedString(@"选择您的EOS账号", nil);
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
    //https://dapp.newdex.io/    https://game.wizards.one/#/ https://app.deosgames.com/en/slots/deos  https://pixelmaster.io/ https://www.xpet.io/
    NSString *requestStr;
    requestStr = @"https://dapp.newdex.io/";
//    requestStr = [NSString stringWithFormat:@"%@",self.model.url];
    NSURLRequest *finalRequest = [NSURLRequest requestWithURL:String_To_URL(requestStr)];
    [self.webView loadRequest: finalRequest];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
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


- (NSString *)getInjectJS{
    //compress_xinxin testScatterSONG
    NSString *JSfilePath = [[NSBundle mainBundle]pathForResource:@"compress_xinxin" ofType:@"js"];
    NSString *content = [NSString stringWithContentsOfFile:JSfilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *final = [@"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \""
                       stringByAppendingString:content];
    return final;
}


@end
