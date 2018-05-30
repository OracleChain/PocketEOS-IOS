//
//  TransactionRecord.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransactionRecord.h"

@implementation TransactionRecord
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"transactionType" : @"transaction.transaction.actions[0].name",
             @"from" : @"transaction.transaction.actions[0].data.from",
             @"to" : @"transaction.transaction.actions[0].data.to",
             @"quantity" : @"transaction.transaction.actions[0].data.quantity",
             @"memo" : @"transaction.transaction.actions[0].data.memo",
             @"expiration" : @"transaction.transaction.expiration",
             @"ref_block_num" : @"transaction.transaction.ref_block_num"
             };
}
@end

