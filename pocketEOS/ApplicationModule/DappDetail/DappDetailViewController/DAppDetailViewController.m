//
//  DAppDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 09/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DAppDetailViewController.h"
#import "WkDelegateController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginPasswordView.h"
#import "TransferService.h"
#import "CDZPicker.h"
#import "SelectAccountView.h"
#import "TransferAbi_json_to_bin_request.h"
#import "DappTransferModel.h"
#import "DappTransferResult.h"

@interface DAppDetailViewController ()<UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler, WKDelegate , TransferServiceDelegate, LoginPasswordViewDelegate, SelectAccountViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) TransferService *mainService;
@property(nonatomic, strong) NSDictionary *WKScriptMessageBody;// recieve WKScriptMessage.body
@property(nonatomic, strong) SelectAccountView *selectAccountView;
@property(nonatomic, strong) NSString *choosedAccountName;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic , strong) DappTransferModel *dappTransferModel;
@end

@implementation DAppDetailViewController

- (WKWebView *)webView{
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        self.userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = self.userContentController;
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) configuration:configuration];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = @"PocketEosIos";
        } else {
            // Fallback on earlier versions
        }
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"pushAction"];
    if (IsStrEmpty(self.webView.title)) {
        [self.webView reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushAction('%@','%@')"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    self.title = self.model.applyName;
    [self.view addSubview:self.selectAccountView];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSString *js = [NSString stringWithFormat:@"getEosAccount('%@')", self.choosedAccountName];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    if ([message.name isEqualToString:@"pushAction"]) {
        [self.view addSubview:self.loginPasswordView];
        self.WKScriptMessageBody = (NSDictionary *)message.body;
    }
    
    if ([message.name isEqualToString:@"Share"]) {
        NSString *jsStr = [NSString stringWithFormat:@"pushActionResult('%@')",@"shi1234ww"];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    }
}



// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:@"密码输入错误!"];
        return;
    }
    DappTransferResult *result = [DappTransferResult mj_objectWithKeyValues:self.WKScriptMessageBody];
    self.dappTransferModel = (DappTransferModel *)[DappTransferModel mj_objectWithKeyValues:[result.message mj_JSONObject ] ];
    self.dappTransferModel.serialNumber = result.serialNumber;
    
    self.transferAbi_json_to_bin_request.code = @"octoneos";//octoneos
    self.mainService.code = @"octoneos";//octoneos
    self.transferAbi_json_to_bin_request.quantity = self.dappTransferModel.quantity;
    self.transferAbi_json_to_bin_request.action = @"transfer";
    self.transferAbi_json_to_bin_request.from = self.dappTransferModel.from;
    self.transferAbi_json_to_bin_request.to = self.dappTransferModel.to;
    self.transferAbi_json_to_bin_request.memo = self.dappTransferModel.memo;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.choosedAccountName];
        weakSelf.mainService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
        weakSelf.mainService.action = @"transfer";
        weakSelf.mainService.sender = weakSelf.choosedAccountName;
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
        weakSelf.loginPasswordView = nil;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:@"交易成功!"];
        
        NSString *jsStr = [NSString stringWithFormat:@"pushActionResult('%@', '%@')",VALIDATE_STRING(result.transaction_id), self.dappTransferModel.serialNumber];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}

//SelectAccountViewDelegate
- (void)selectAccountBtnDidClick:(UIButton *)sender{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = UIColor.redColor;
    WS(weakSelf);
    
    NSArray *accountNameArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
    if (accountNameArr.count == 0) {
        [TOASTVIEW showWithText:@"暂无账号!"];
        return;
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:[[AccountsTableManager accountTable] selectAllNativeAccountName] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.selectAccountView.accountChooseLabel.text = [NSString stringWithFormat:@"%@" , strings[0]];
        weakSelf.choosedAccountName = VALIDATE_STRING(strings[0]);
    }cancel:^{
        [weakSelf.selectAccountView removeFromSuperview];
    }];
    
}

- (void)understandBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.choosedAccountName)) {
        [TOASTVIEW showWithText:@"请选择您将选择的账号!"];
        return;
    } else{
        [self.selectAccountView removeFromSuperview];
        
        [self.webView loadRequest: [NSURLRequest requestWithURL:String_To_URL(self.model.url)]];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        [self.view addSubview:self.webView];
    }
}

-(void)backgroundViewDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
