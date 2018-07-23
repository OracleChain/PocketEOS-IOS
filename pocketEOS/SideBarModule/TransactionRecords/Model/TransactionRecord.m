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
             @"transactionType" : @"doc.name",
             @"from" : @"doc.data.from",
             @"to" : @"doc.data.to",
             @"quantity" : @"doc.data.quantity",
             @"memo" : @"doc.data.memo",
             @"expiration" : @"doc.data.expiration"
             };
}
@end
