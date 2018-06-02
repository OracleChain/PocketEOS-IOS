//
//  NewsDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/15.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "NSURLProtocol+WKWebVIew.h"
#import "JWCacheURLProtocol.h"

@interface NewsDetailViewController ()< WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation NewsDetailViewController

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT))];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.navigationController.navigationBar.lee_theme.LeeConfigTintColor(@"common_font_color_1");
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    //使用方法，在开启webview的时候开启监听，，销毁weibview的时候取消监听，否则监听还在继续。将会监听所有的网络请求
    [JWCacheURLProtocol startListeningNetWorking];
    [self.view addSubview:self.webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:String_To_URL(VALIDATE_STRING(self.urlStr))]];
}

- (void)dealloc{
    [JWCacheURLProtocol cancelListeningNetWorking];//在不需要用到webview的时候即使的取消监听
}


@end
