//
//  ScanQRCodeSuccessViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ScanQRCodeSuccessViewController.h"
#import <SafariServices/SafariServices.h>

@interface ScanQRCodeSuccessViewController ()
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation ScanQRCodeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
    
}
// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 64, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 100, SCREEN_WIDTH, 400);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    if (@available(iOS 9.0, *)) {
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL: String_To_URL(self.jump_URL)];
        [self presentViewController: safariViewController animated: YES completion: nil];
    } else {
        // Fallback on earlier versions
    }
}
@end
