//
//  Get_account_assetsResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_account_assetsResult.h"

@implementation Get_account_assetsResult

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"user_asset_list" : @"data.user_asset_list"
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"user_asset_list" : @"TokenInfo" };
}

@end
