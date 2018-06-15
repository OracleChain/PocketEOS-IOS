//
//  UnstakeEosAbiJsonTobinRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/15.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "UnstakeEosAbiJsonTobinRequest.h"

@implementation UnstakeEosAbiJsonTobinRequest
-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.receiver) forKey:@"receiver"];
    [args setObject:VALIDATE_STRING(self.unstake_net_quantity) forKey:@"unstake_net_quantity"];
    [args setObject:VALIDATE_STRING(self.unstake_cpu_quantity) forKey:@"unstake_cpu_quantity"];
    [params setObject:args forKey:@"args"];
    return params;
}

@end
