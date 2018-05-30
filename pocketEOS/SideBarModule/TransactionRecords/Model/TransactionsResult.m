//
//  TransactionsResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransactionsResult.h"

@implementation TransactionsResult
+(NSDictionary *)mj_objectClassInArray{
    return @{ @"transactions" : @"TransactionRecord"};
}
@end
