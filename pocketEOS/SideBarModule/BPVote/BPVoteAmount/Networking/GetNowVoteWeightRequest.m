//
//  GetNowVoteWeightRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetNowVoteWeightRequest.h"

@implementation GetNowVoteWeightRequest
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/voteoraclechain/GetNowVoteWeight", REQUEST_BP_BASEURL];
}


@end
