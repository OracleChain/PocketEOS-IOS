//
//  RtfBrowserWithoutThemeViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/14.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RtfBrowserWithoutThemeViewController.h"

@interface RtfBrowserWithoutThemeViewController ()
@property(nonatomic , strong) UIWebView *webView;
@end

@implementation RtfBrowserWithoutThemeViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT);
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0xFFFFFF);
    self.view.backgroundColor = HEXCOLOR(0x161823);
    NSURL *rtfUrl = [[NSBundle mainBundle] URLForResource:self.rtfFileName withExtension:@"rtf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:rtfUrl];
    [_webView loadRequest:request];
}
@end
