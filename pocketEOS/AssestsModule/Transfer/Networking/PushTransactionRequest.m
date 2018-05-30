//
//  PushTransactionRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PushTransactionRequest.h"

@implementation PushTransactionRequest

-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/push_transaction" , REQUEST_BLOCKCHAIN_BASEURL];
    return @"/push_transaction";
}

-(NSDictionary *)parameters{
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.packed_trx) forKey:@"packed_trx"];
    [transacDic setObject:@[self.signatureStr] forKey:@"signatures"];
    [transacDic setObject:@"none" forKey:@"compression"];
    [transacDic setObject:@"00" forKey:@"packed_context_free_data"];
    return transacDic;
}

@end
