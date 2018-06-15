//
//  BPCandidateService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetBPCandidateListRequest.h"

@interface BPCandidateService : BaseService

@property(nonatomic , strong) GetBPCandidateListRequest *getBPCandidateListRequest;
- (void)buildNextPageDataSource:(CompleteBlock)complete;
@end
