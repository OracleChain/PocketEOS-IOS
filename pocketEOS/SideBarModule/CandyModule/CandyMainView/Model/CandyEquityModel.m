//
//  CandyEquityModel.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CandyEquityModel.h"

@implementation CandyEquityModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"equity_id" : @"id" ,
             @"equity_description" : @"description"
             };
}
@end
