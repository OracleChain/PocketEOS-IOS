//
//  Application.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "Application.h"

@implementation Application
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"application_id" : @"id"};
}
@end
