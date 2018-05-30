//
//  MessageFeedbackService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "MessageFeedbackService.h"
#import "MessageFeedbackResult.h"


@implementation MessageFeedbackService

- (GetFeedbackListRequest *)getFeedbackListRequest{
    if (!_getFeedbackListRequest) {
        _getFeedbackListRequest = [[GetFeedbackListRequest alloc] init];
    }
    return _getFeedbackListRequest;
}

- (PostFeedbackRequest *)postFeedbackRequest{
    if (!_postFeedbackRequest) {
        _postFeedbackRequest = [[PostFeedbackRequest alloc] init];
    }
    return _postFeedbackRequest;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getFeedbackListRequest.size = @(15);
    self.getFeedbackListRequest.offset = @(0);
    [self.getFeedbackListRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        MessageFeedbackResult *result = [MessageFeedbackResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            
        }
        complete(@(result.data.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)buildNextPageDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getFeedbackListRequest.size = @(15);
    self.getFeedbackListRequest.offset = @(self.dataSourceArray.count);
    [self.getFeedbackListRequest postDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        
        MessageFeedbackResult *result = [MessageFeedbackResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
            
        }
        complete(@(result.data.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}


@end
