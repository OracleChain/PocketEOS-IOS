//
//  GetRequiredPublicKeyRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetRequiredPublicKeyRequest.h"

@implementation GetRequiredPublicKeyRequest
-(NSString *)requestUrlPath{
    //    return [NSString stringWithFormat:@"%@/get_required_keys" , REQUEST_BLOCKCHAIN_BASEURL];
    return @"/get_required_keys";
}

-(NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_kcpu_usage"];
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [actionDict setObject:self.name forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.data) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:VALIDATE_STRING(self.sender) forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:VALIDATE_ARRAY(self.available_keys) forKey:@"available_keys"];
    return params;
}

@end

