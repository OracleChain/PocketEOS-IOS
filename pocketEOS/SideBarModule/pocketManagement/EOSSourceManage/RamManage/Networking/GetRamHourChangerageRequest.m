//
//  GetRamHourChangerageRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetRamHourChangerageRequest.h"

@implementation GetRamHourChangerageRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/eosDataConditionSearchRam/GetHourChangerage", REQUEST_HISTORY_HTTP];
}

@end
