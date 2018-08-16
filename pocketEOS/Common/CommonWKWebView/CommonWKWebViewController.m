//
//  CommonWKWebViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/6.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CommonWKWebViewController.h"
#import "WkDelegateController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CommonWKWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic , strong) WKProcessPool *sharedProcessPool;
@end

@implementation CommonWKWebViewController

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
        
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if (self.webView.title == nil) {
        [self.webView reload];
    }
      [MobClick beginLogPageView:self.title]; //("Pagename"为页面名称，可自定义)
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
//    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    
    // 解决顶部出现空白
    self.automaticallyAdjustsScrollViewInsets=NO;//自动滚动调整，默认为YES
    
    
    
    [self.view addSubview:self.webView];
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    // 方式二
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0x2A2A2A);
    
//    NSURLRequest *originalRequest = [NSURLRequest requestWithURL:String_To_URL(self.urlStr)];
//    [self.webView loadRequest: originalRequest];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@",self.urlStr,self.parameterStr];
    NSURLRequest *finalRequest = [NSURLRequest requestWithURL:String_To_URL(requestStr)];
    [self.webView loadRequest: finalRequest];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
    NSLog(@"reload");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"%s", __FUNCTION__);
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
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
