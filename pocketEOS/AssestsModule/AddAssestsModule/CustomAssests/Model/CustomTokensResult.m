//
//  CustomTokensResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CustomTokensResult.h"

@implementation CustomTokensResult

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : @"CustomToken"
             
             };
}
@end
