//
//  ThirdPayManager.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ThirdPayManager.h"

@implementation ThirdPayManager

// wechatPay
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ThirdPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ThirdPayManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
extern NSString *WechatPayDidFinishNotification;
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
         [[NSNotificationCenter defaultCenter] postNotificationName:WechatPayDidFinishNotification object:resp];
        
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }else {
    }
}

- (void)onReq:(BaseReq *)req {
    
}

@end
