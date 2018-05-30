//
//  JavascriptWebViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "JavascriptWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface JavascriptWebViewController ()
@property WebViewJavascriptBridge* bridge;
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation JavascriptWebViewController

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame: CGRectZero ];
    }
    return _webView;
}
// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏默认的navigationBar
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.webView];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    
    //调用逻辑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Javascript" ofType:@"html"];
    if(path){
        if (@available(iOS 9.0, *)) {
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            // Fallback on earlier versions
            NSURLRequest *request = [NSURLRequest requestWithURL:[QuoteLocalHtmlTool fileURLForBuggyWKWebView8: String_To_URL(path)]];
            [self.webView loadRequest:request];
        }
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"testJavascriptHandler", @"privateKeyGen", @"privateToPublic", @"isValidPrivate", @"isValidPublic", @"sign", @"verify", @"sha256", nil];
    for (int i = 0 ; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        btn.backgroundColor = RandomColor;
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(50, 200 + i * 50, 200, 40);
        [self.view addSubview:btn];
    }
    
    // 注册 js 的方法 testObjcCallback
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
}
- (void)btnDidClick:(UIButton *)sender{
    if (sender.tag == 1000){
        //testJavascriptHandler
        [self callHandler:nil];
    }else if (sender.tag == 1001){
        //生成私钥privateKeyGen
        [self privateKeyGen: @"makePriv"];
    }else if (sender.tag == 1002){
        //根据私钥生成公钥privateToPublic
        [self privateToPublic:@"makePub" andPriv_key:@"5KTXrkyvdxAhGpw3DLJsiZvSdEwi3u6gMQQ3qKbsYjm6CTErqxZ"];
    }
    else if (sender.tag == 1003){
        //验证私钥格式isValidPrivate
        
        [self isValidPrivate:@"isValidPrivate" andPriv_key:@"5JkgC3U4X1ymcrYVhFDbiVUpD6a7wtfZ13Nd4nuaBGLkBwLu2Z7" ];
        
    }else if (sender.tag == 1004){
        //验证公钥格式isValidPublic
        [self isValidPublic:@"isValidPublic" andPub_key:@"EOS8damnMBH3QSkHRM62H86zFyDuB2GUKDqp6SjrQYZXwwSK27Jkq"];
        
    }else if (sender.tag == 1005){
        //签名sign
        [self sign:@"sign" andData:@"12345" andPriv_key:@"5KTXrkyvdxAhGpw3DLJsiZvSdEwi3u6gMQQ3qKbsYjm6CTErqxZ"];
        
    }else if (sender.tag == 1006){
        //验证签名verify
        [self verify:@"verify" andSign:@"1f76ce8f2ebf857229b4e56bc3e0c064d75fe125f864f5a2d63d96aee5a55e7b3d481f0989fb6db41980e2586c24dd9909d5eb1020c8221af5691d192f94c2676c" andData:@"12345" andPub_key:@"EOS8damnMBH3QSkHRM62H86zFyDuB2GUKDqp6SjrQYZXwwSK27Jkq"];
        
    }else if (sender.tag == 1007){
        //SHA256sha256
        [self sha256:@"sha256" andData:@"12345"];
        
    }
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [self.bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

//生成私钥privateKeyGen
- (void)privateKeyGen:(NSString *)tid{
    [self.bridge callHandler:@"privateKeyGen" data:tid responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//根据私钥生成公钥privateToPublic
- (void)privateToPublic:(NSString *)tid andPriv_key:(NSString *)priv_key{
    id params = @{ @"tid": tid, @"priv_key" : priv_key };
    [self.bridge callHandler:@"privateToPublic" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//验证私钥格式isValidPrivate
- (void)isValidPrivate:(NSString *)tid andPriv_key:(NSString *)priv_key{
    id params = @{ @"tid": tid, @"priv_key" : priv_key };
    [self.bridge callHandler:@"isValidPrivate" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//验证公钥格式isValidPublic
- (void)isValidPublic:(NSString *)tid andPub_key:(NSString *)pub_key{
    id params = @{ @"tid": tid, @"pub_key" : pub_key };
    [self.bridge callHandler:@"isValidPublic" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//签名sign
- (void)sign:(NSString *)tid andData:(id)data andPriv_key:(NSString *)priv_key{
    id params = @{ @"tid": tid, @"sign_data" : data , @"priv_key" : priv_key };
    [self.bridge callHandler:@"sign" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//验证签名verify
- (void)verify:(NSString *)tid andSign:(NSString *)sign andData:(id)data andPub_key:(NSString *)pub_key{
    id params = @{ @"tid": tid, @"sign" : sign , @"verify_data" : data,  @"pub_key" : pub_key };
    [self.bridge callHandler:@"verify" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
//SHA256
- (void)sha256:(NSString *)tid andData:(id)data{
    id params = @{ @"tid": tid, @"sha256_data" : data  };
    [self.bridge callHandler:@"sha256" data:params responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}
@end
