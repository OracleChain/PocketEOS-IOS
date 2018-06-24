//
//  PriceModel.m
//  pocketEOS
//
//  Created by 师巍巍 on 22/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PriceModel.h"

@implementation PriceModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"quote_balance" : @"rows[0].quote.balance",
             @"base_balance" : @"rows[0].base.balance",
             
             };
}
@end
