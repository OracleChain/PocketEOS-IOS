//
//  GetTokenInfoResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetTokenInfoResult.h"

@implementation GetTokenInfoResult

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             
             @"data" : @"TokenInfo"
             
             };
}

@end
