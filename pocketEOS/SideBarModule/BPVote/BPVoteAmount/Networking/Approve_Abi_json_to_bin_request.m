//
//  Approve_Abi_json_to_bin_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/11.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Approve_Abi_json_to_bin_request.h"

@implementation Approve_Abi_json_to_bin_request

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
    [args setObject:VALIDATE_STRING(self.stake_net_quantity) forKey:@"stake_net_quantity"];
    [args setObject:VALIDATE_STRING(self.stake_cpu_quantity) forKey:@"stake_cpu_quantity"];
    [args setObject:VALIDATE_STRING(self.transfer) forKey:@"transfer"];
    [params setObject:args forKey:@"args"];
    return params;
}
@end
