//
//  BPCandidateService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateService.h"
#import "BPCandidateResult.h"
#import "BPCandidateDetailResult.h"
#import "BPCandidateModel.h"

@implementation BPCandidateService

- (GetBPCandidateListRequest *)getBPCandidateListRequest{
    if (!_getBPCandidateListRequest) {
        _getBPCandidateListRequest = [[GetBPCandidateListRequest alloc] init];
    }
    return _getBPCandidateListRequest;
}

- (void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getBPCandidateListRequest.pageNum = @0;
    self.getBPCandidateListRequest.pageSize = @(PER_PAGE_SIZE_15);
    [self.getBPCandidateListRequest postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.responseArray removeAllObjects];
        [weakSelf.dataSourceArray removeAllObjects];
        BPCandidateResult *listResult = [BPCandidateResult mj_objectWithKeyValues:data];
        if (![listResult.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(listResult.msg)];
            complete(@(0), YES);
        }else{
            BPCandidateDetailResult *result = [BPCandidateDetailResult mj_objectWithKeyValues:listResult.data];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            complete(@(result.data.count), YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
    
}

- (void)buildNextPageDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getBPCandidateListRequest.pageNum = @(self.dataSourceArray.count / PER_PAGE_SIZE_15);
    self.getBPCandidateListRequest.pageSize = @(PER_PAGE_SIZE_15);
    [self.getBPCandidateListRequest postOuterDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        BPCandidateResult *listResult = [BPCandidateResult mj_objectWithKeyValues:data];
        if (![listResult.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(listResult.msg)];
            complete(@(0), YES);
        }else{
            BPCandidateDetailResult *result = [BPCandidateDetailResult mj_objectWithKeyValues:listResult.data];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
            complete(@(result.data.count), YES);
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
@end
