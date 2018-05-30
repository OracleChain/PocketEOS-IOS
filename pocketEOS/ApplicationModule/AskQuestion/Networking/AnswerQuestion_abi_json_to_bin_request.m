//
//  AnswerQuestion_abi_json_to_bin_request.m
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AnswerQuestion_abi_json_to_bin_request.h"

@implementation AnswerQuestion_abi_json_to_bin_request
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
    [args setObject:VALIDATE_NUMBER(self.from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.askid) forKey:@"askid"];
    [args setObject:VALIDATE_STRING(self.choosedanswer) forKey:@"choosedanswer"];
    [params setObject:args forKey:@"args"];
    return params;
}

@end
