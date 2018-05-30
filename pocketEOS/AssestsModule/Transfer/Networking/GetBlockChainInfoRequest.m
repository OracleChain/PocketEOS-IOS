//
//  GetBlockChainInfoRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetBlockChainInfoRequest.h"

@implementation GetBlockChainInfoRequest

-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/get_info" , REQUEST_BLOCKCHAIN_BASEURL];
    return @"/get_info";
}


@end
