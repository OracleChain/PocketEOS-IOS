//
//  AskQuestion_abi_to_json_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AskQuestion_abi_to_json_request.h"

@implementation AskQuestion_abi_to_json_request
-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/abi_json_to_bin" , REQUEST_BLOCKCHAIN_BASEURL];
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:@"1" forKey:@"id"];
    [args setObject:VALIDATE_STRING(self.from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.quantity) forKey:@"quantity"];
    [args setObject:VALIDATE_NUMBER(@0) forKey:@"createtime"];
    [args setObject:VALIDATE_NUMBER(self.endtime) forKey:@"endtime"];
    [args setObject:VALIDATE_NUMBER(self.optionanswerscnt) forKey:@"optionanswerscnt"];
    [args setObject:VALIDATE_STRING(self.asktitle) forKey:@"asktitle"];
    [args setObject:VALIDATE_STRING(self.optionanswers) forKey:@"optionanswers"];
    
    [params setObject:args forKey:@"args"];
    return params;
}

@end
