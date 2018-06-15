//
//  EOSMappingResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSMappingResult.h"

@implementation EOSMappingResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"account_names" : @"data.account_names"};
}
@end
