//
//  BPCandidateDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/14.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateDetailViewController.h"

@interface BPCandidateDetailViewController ()< WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation BPCandidateDetailViewController
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT))];
        _webView.navigationDelegate = self;
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0xFFFFFF);
    self.view.backgroundColor = HEXCOLOR(0x161823);
    [self.view addSubview:self.webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:String_To_URL(VALIDATE_STRING(self.urlStr))]];
}
@end
