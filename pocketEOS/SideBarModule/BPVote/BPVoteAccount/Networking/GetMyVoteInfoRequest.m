//
//  GetMyVoteInfoRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetMyVoteInfoRequest.h"

@implementation GetMyVoteInfoRequest
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/voteoraclechain/GetMyVoteInfo", REQUEST_BP_BASEURL];
}

-(id)parameters{
    return @{@"accountNameStr": VALIDATE_STRING(self.accountNameStr)};
}
@end
