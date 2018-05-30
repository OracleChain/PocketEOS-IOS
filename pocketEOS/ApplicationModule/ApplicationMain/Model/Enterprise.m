//
//  Enterprise.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "Enterprise.h"

@implementation Enterprise
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"enterprise_id" : @"id"};
}
@end
