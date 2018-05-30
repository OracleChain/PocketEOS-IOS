//
//  SystemSettingService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/17.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SystemSettingService.h"

@implementation SystemSettingService
-(void)buildDataSource:(CompleteBlock)complete{
    
    self.dataSourceArray = [NSMutableArray arrayWithObjects:@"清空缓存", @"法律条款与隐私政策", @"关于Pocket EOS",  nil];
//    self.dataSourceArray = [NSMutableArray arrayWithObjects:@"跟随手机系统", @"简体中文", @"English", nil];
    complete(self , YES);
}
@end

// 设置语言
//    if (indexPath.row == 0) {
//        [DAConfig setUserLanguage:nil];
//    } else if (indexPath.row == 1) {
//        [DAConfig setUserLanguage:@"zh-Hans"];
//    } else {
//        [DAConfig setUserLanguage:@"en"];
//    }
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (UIView *view in WINDOW.subviews) {
//            [view removeFromSuperview];
//        }
//        AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        BaseTabBarController * vc =[[BaseTabBarController alloc]init];
//        appDele.window.rootViewController = vc;
//        [TOASTVIEW showWithText:NSLocalizedString(@"语言切换中", nil) duration:1];
//
//    });
