//
//  Discover_Category_config_model.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Discover_Category_config_model.h"

@implementation Discover_Category_config_model
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"dappCategory_id" : @"id"
             };
}
@end
