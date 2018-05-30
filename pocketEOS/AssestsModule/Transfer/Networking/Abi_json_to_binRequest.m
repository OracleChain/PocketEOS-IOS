//
//  Abi_to_json.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "Abi_json_to_binRequest.h"

@implementation Abi_json_to_binRequest

-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/abi_json_to_bin" , REQUEST_BLOCKCHAIN_BASEURL];
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.to) forKey:@"to"];
    [args setObject:VALIDATE_STRING(self.memo) forKey:@"memo"];
    [args setObject:VALIDATE_STRING(self.quantity) forKey:@"quantity"];
    [params setObject:args forKey:@"args"];
    return params;
}


@end
