//
//  GetCurrentRamPriceRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetCurrentRamPriceRequest.h"

@implementation GetCurrentRamPriceRequest


-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/eosDataConditionSearchRam/GetRamTrades", REQUEST_HISTORY_HTTP];
}


@end
