//
//  Permissions.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/6.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "Permission.h"

@implementation Permission
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"required_auth_key" : @"required_auth.keys[0].key"
             };
}
@end
