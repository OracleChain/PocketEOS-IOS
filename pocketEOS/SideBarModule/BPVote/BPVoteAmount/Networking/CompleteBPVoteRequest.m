//
//  CompleteBPVoteRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CompleteBPVoteRequest.h"

@implementation CompleteBPVoteRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/complete_task", REQUEST_CANDYSYSTEM_BASEURL];
}
-(id)parameters{
    // bp 投票任务 id
    return @{@"id" : @"c0b92ad2a778418c9ec860f3f7e79c21" ,
             @"uid" : CURRENT_WALLET_UID
             };
}
@end
