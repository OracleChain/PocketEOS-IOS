//
//  PayOrderRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PayOrderRequest.h"

@implementation PayOrderRequest

- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/payOrder", REQUEST_TOKENPAY_BASEURL];
}

-(id)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.userId) forKey:@"userId"];
    [params setObject:VALIDATE_STRING(self.outTradeNo) forKey:@"outTradeNo"];
    [params setObject:VALIDATE_STRING(self.trxId) forKey:@"trxId"];
    [params setObject:VALIDATE_STRING(self.memo) forKey:@"memo"];
    [params setObject:VALIDATE_STRING(self.blockNum) forKey:@"blockNum" ];
    [params setObject:VALIDATE_STRING(self.prepayId) forKey:@"prepayId" ];
    return [params clearEmptyObject];
}

@end
