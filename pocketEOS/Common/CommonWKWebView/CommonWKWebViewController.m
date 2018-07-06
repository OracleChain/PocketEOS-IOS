//
//  CommonWKWebViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/6.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CommonWKWebViewController.h"

@interface CommonWKWebViewController ()<WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation CommonWKWebViewController

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT))];
        _webView.navigationDelegate = self;
        
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
//    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    
    [self.view addSubview:self.webView];
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    // 方式二
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0x2A2A2A);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:String_To_URL(VALIDATE_STRING(self.urlStr))]];
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
    NSLog(@"rewlopad");
}

@end
