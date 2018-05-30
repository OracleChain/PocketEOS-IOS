//
//  WkDelegateController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "WkDelegateController.h"

@interface WkDelegateController ()

@end

@implementation WkDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
