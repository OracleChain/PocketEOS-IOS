//
//  Abi_bin_to_jsonRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Abi_bin_to_jsonRequest.h"

@implementation Abi_bin_to_jsonRequest



-(NSString *)requestUrlPath{
    return @"/abi_bin_to_json";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    [params setObject:VALIDATE_STRING(self.binargs) forKey:@"binargs"];
    return [params clearEmptyObject];
}


@end
