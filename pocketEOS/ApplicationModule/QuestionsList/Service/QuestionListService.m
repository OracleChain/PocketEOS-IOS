//
//  QuestionListService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/3.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "QuestionListService.h"
#import "QuestionsListResult.h"
#import "QuestionListDetailResult.h"
#import "Question.h"

@implementation QuestionListService

- (GetQuestionListRequest *)getQuestionListRequest{
    if (!_getQuestionListRequest) {
        _getQuestionListRequest = [[GetQuestionListRequest alloc] init];
        
    }
    return _getQuestionListRequest;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getQuestionListRequest.askid = @-1;
    self.getQuestionListRequest.pageNum = @0;
    self.getQuestionListRequest.pageSize = @(PER_PAGE_SIZE_15);
    [self.getQuestionListRequest postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        QuestionsListResult *listResult = [QuestionsListResult mj_objectWithKeyValues:data];
        if (![listResult.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(listResult.msg)];
            complete(@(0), YES);
        }else{
            QuestionListDetailResult *result = [QuestionListDetailResult mj_objectWithKeyValues:listResult.data];
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
    self.getQuestionListRequest.askid = @-1;
    self.getQuestionListRequest.pageNum = @(self.dataSourceArray.count / PER_PAGE_SIZE_15);
    self.getQuestionListRequest.pageSize = @(PER_PAGE_SIZE_15);
    [self.getQuestionListRequest postOuterDataSuccess:^(id DAO, id data) {

        [weakSelf.responseArray removeAllObjects];
        QuestionsListResult *listResult = [QuestionsListResult mj_objectWithKeyValues:data];
        if (![listResult.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(listResult.msg)];
            complete(@(0), YES);
        }else{
            QuestionListDetailResult *result = [QuestionListDetailResult mj_objectWithKeyValues:listResult.data];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
            complete(@(result.data.count), YES);
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
@end
