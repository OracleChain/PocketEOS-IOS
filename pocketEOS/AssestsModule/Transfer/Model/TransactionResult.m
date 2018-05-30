//
//  TransactionResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransactionResult.h"

@implementation TransactionResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"transaction_id" : @"data.transaction_id"
             };
}
@end
