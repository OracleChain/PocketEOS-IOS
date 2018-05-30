//
//  GetRateRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetRateRequest.h"

@implementation GetRateRequest
-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/get_rate", REQUEST_BLOCKCHAIN_BASEURL];
    return @"/get_rate";
}

-(id)parameters{
    return @{@"coinmarket_id" : VALIDATE_STRING(self.coinmarket_id) };
}

@end
