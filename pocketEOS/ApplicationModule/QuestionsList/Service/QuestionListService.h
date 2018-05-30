
//
//  QuestionListService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/3.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetQuestionListRequest.h"


@interface QuestionListService : BaseService

@property(nonatomic, strong) GetQuestionListRequest *getQuestionListRequest;
- (void)buildNextPageDataSource:(CompleteBlock)complete;
@end
