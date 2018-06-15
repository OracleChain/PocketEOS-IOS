//
//  BPVoteService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteService.h"
#import "MyVoteInfo.h"
#import "MyVoteProduce.h"
#import "MyVoteInfoResult.h"

@interface BPVoteService()

@end


@implementation BPVoteService

- (GetMyVoteInfoRequest *)getMyVoteInfoRequest{
    if (!_getMyVoteInfoRequest) {
        _getMyVoteInfoRequest = [[GetMyVoteInfoRequest alloc] init];
    }
    return _getMyVoteInfoRequest;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [self.getMyVoteInfoRequest postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        
        MyVoteInfoResult *result = [MyVoteInfoResult mj_objectWithKeyValues:data];
        [weakSelf.dataSourceArray addObjectsFromArray:[MyVoteProduce mj_objectArrayWithKeyValuesArray:result.producers]];
        complete(result, YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

@end
