//
//  ScatterResult_identityFromPermissions.m
//  PocketSocket
//
//  Created by oraclechain on 2018/9/17.
//  Copyright © 2018 Zwopple Limited. All rights reserved.
//

#import "ScatterResult_type_identityFromPermissions.h"

@implementation ScatterResult_type_identityFromPermissions

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"scatterResult_id" : @"data.id",
             @"scatterResult_appkey" : @"data.appkey"
             };
}

@end
