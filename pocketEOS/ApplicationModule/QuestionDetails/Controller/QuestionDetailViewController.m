//
//  QuestionDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "WkDelegateController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Question.h"
#import "TransferService.h"
#import "LoginPasswordView.h"
#import "AnswerQuestion_abi_json_to_bin_request.h"
#import "ApproveAbi_json_to_bin_request.h"
#import "AskQuestionTipView.h"

@interface QuestionDetailViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler, WKDelegate , TransferServiceDelegate, LoginPasswordViewDelegate, AskQuestionTipViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic, strong) TransferService *transferService;
@property(nonatomic , strong) AnswerQuestion_abi_json_to_bin_request *answerQuestion_abi_json_to_bin_request;
@property(nonatomic , strong) ApproveAbi_json_to_bin_request *approveAbi_json_to_bin_request;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, copy) NSString *WKScriptMessageBody;// recieve WKScriptMessage.body
@property(nonatomic, strong) AskQuestionTipView *askQuestionTipView;
@end

@implementation QuestionDetailViewController

- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}

- (AnswerQuestion_abi_json_to_bin_request *)answerQuestion_abi_json_to_bin_request{
    if (!_answerQuestion_abi_json_to_bin_request) {
        _answerQuestion_abi_json_to_bin_request = [[AnswerQuestion_abi_json_to_bin_request alloc] init];
    }
    return _answerQuestion_abi_json_to_bin_request;
}

- (ApproveAbi_json_to_bin_request *)approveAbi_json_to_bin_request{
    if (!_approveAbi_json_to_bin_request) {
        _approveAbi_json_to_bin_request = [[ApproveAbi_json_to_bin_request alloc] init];
    }
    return _approveAbi_json_to_bin_request;
}
- (WKWebView *)webView{
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        self.userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = self.userContentController;
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) configuration:configuration];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
       
    }
    return _webView;
}
- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

- (AskQuestionTipView *)askQuestionTipView{
    if (!_askQuestionTipView) {
        _askQuestionTipView = [[[NSBundle mainBundle] loadNibNamed:@"AskQuestionTipView" owner:nil options:nil] firstObject];
        _askQuestionTipView.frame = self.view.bounds;
        _askQuestionTipView.delegate = self;
    }
    return _askQuestionTipView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Share"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"shareOuter"];
    if (IsStrEmpty(self.webView.title)) {
        [self.webView reload];
    }
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"shareOuter"];
     [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Share"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    NSString *url = [NSString stringWithFormat:@"%@/#/answer", REQUEST_CONTRACT_BASEURL];
    [self.webView loadRequest: [NSURLRequest requestWithURL:String_To_URL(url)]];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)sayHello:(UIButton *)sender{
    [self.webView evaluateJavaScript:@"say()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
    }];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *js = [NSString stringWithFormat:@"getquestion(%@,%@)", self.question.question_id , self.question.releasedLable];
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
    if ([message.name isEqualToString:@"Share"]) {
        self.WKScriptMessageBody = (NSString *)message.body;
        [self.view addSubview:self.askQuestionTipView];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"回答此问题将抵押您 %@ OCT ", @"1"]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x2A2A2A)
                           range:NSMakeRange(0, 9)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0xB51515)
                           range:NSMakeRange(10, 1)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x2A2A2A)
                           range:NSMakeRange(11, 3)];
        self.askQuestionTipView.titleLabel.attributedText = attrString;
        
        
    }
}


// AskQuestionTipViewDelegate
- (void)askQuestionTipViewCancleBtnDidClick:(UIButton *)sender{
    [self.askQuestionTipView removeFromSuperview];
}

- (void)askQuestionTipViewConfirmBtnDidClick:(UIButton *)sender{
    [self.askQuestionTipView removeFromSuperview];
    if (self.loginPasswordView) {
        self.loginPasswordView.inputPasswordTF.text = nil;
    }
    [self.view addSubview:self.loginPasswordView];
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
    
    
    // 1.押币 2.回答
    [self approve];
    
}

// 押币
- (void)approve{
    [SVProgressHUD show];
    self.approveAbi_json_to_bin_request.action = @"approve";
    self.approveAbi_json_to_bin_request.code = @"octoneos";
    self.approveAbi_json_to_bin_request.owner = self.choosedAccountName;
    self.approveAbi_json_to_bin_request.spender = @"ocaskans";
    self.approveAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"1.0000 OCT"];
    WS(weakSelf);
    [self.approveAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
         #pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
        weakSelf.transferService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
        weakSelf.transferService.action = @"approve";
        weakSelf.transferService.sender = weakSelf.choosedAccountName;
        weakSelf.transferService.code = @"octoneos";
         #pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeApprove;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (void)answerQuestion{
    WS(weakSelf);
    self.answerQuestion_abi_json_to_bin_request.code = @"ocaskans";
    self.answerQuestion_abi_json_to_bin_request.action = @"answer";
    self.answerQuestion_abi_json_to_bin_request.from = self.choosedAccountName;
    self.answerQuestion_abi_json_to_bin_request.askid = self.question.question_id.stringValue;
    self.answerQuestion_abi_json_to_bin_request.choosedanswer = @(self.WKScriptMessageBody.integerValue);
    [self.answerQuestion_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
         #pragma mark -- [@"data"]
        NSLog(@"answer_Question_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
        weakSelf.transferService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
        weakSelf.transferService.action = @"answer";
        weakSelf.transferService.sender = weakSelf.choosedAccountName;
        weakSelf.transferService.code = @"ocaskans";
         #pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeAnswer;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
        weakSelf.loginPasswordView = nil;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//transferserviceDelegate
-(void)answerQuestionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:@"回答问题成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}


-(void)approveDidFinish:(TransactionResult *)result{
        if ([result.code isEqualToNumber:@0 ]) {
    [self answerQuestion];
        }else{
            [TOASTVIEW showWithText: result.message];
        }
}

@end
