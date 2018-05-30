//
//  GetSparklinesRequest.m
//  pocketEOS
//
//  Created by oraclechain on 11/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetSparklinesRequest.h"

@implementation GetSparklinesRequest

-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/get_sparklines" , REQUEST_BLOCKCHAIN_BASEURL];
    return  @"/get_sparklines";
}

@end
