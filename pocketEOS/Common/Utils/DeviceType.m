//
//  DeviceType.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DeviceType.h"

@implementation DeviceType
//如果想要判断设备是ipad，要用如下方法

+ (BOOL)getIsIpad{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    
    if([deviceType isEqualToString:@"iPhone"]) {
        
        //iPhone
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPod touch"]) {
        
        //iPod Touch
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPad"]) {
        
        //iPad
        
        return YES;
        
    }
    
    return NO;
    
}
@end
