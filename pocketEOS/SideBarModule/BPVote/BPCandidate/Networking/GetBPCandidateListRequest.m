//
//  GetBPCandidateListRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetBPCandidateListRequest.h"

@implementation GetBPCandidateListRequest

- (NSString *)requestUrlPath{
    
    return [NSString stringWithFormat:@"%@/voteoraclechain/GetBpJson", REQUEST_BP_BASEURL];
}

- (id)parameters{
    return @{
             @"pageNum" : VALIDATE_STRING(self.pageNum),
             @"pageSize" : VALIDATE_STRING(self.pageSize),
             @"accountName" : VALIDATE_STRING(self.accountName)
             };
}

@end

