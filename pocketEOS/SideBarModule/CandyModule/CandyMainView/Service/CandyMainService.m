//
//  CandyMainService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CandyMainService.h"
#import "CandyTaskResult.h"
#import "CandyEquityResult.h"

@implementation CandyMainService

- (Candy_task_list_request *)candy_task_list_request{
    if (!_candy_task_list_request) {
        _candy_task_list_request = [[Candy_task_list_request alloc] init];
    }
    return _candy_task_list_request;
}

- (Candy_equity_list_request *)candy_equity_list_request{
    if (!_candy_equity_list_request) {
        _candy_equity_list_request = [[Candy_equity_list_request alloc] init];
    }
    return _candy_equity_list_request;
}

- (NSMutableArray *)candyTaskDatasourceArray{
    if (!_candyTaskDatasourceArray) {
        _candyTaskDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _candyTaskDatasourceArray;
}

- (NSMutableArray *)candEquityDatasourceArray{
    if (!_candEquityDatasourceArray) {
        _candEquityDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _candEquityDatasourceArray;
}

- (void)getCandyTasks:(CompleteBlock)complete{
    WS(weakSelf);
    self.candy_task_list_request.uid = CURRENT_WALLET_UID;
    [self.candy_task_list_request getDataSusscess:^(id DAO, id data) {
        CandyTaskResult *result = [CandyTaskResult mj_objectWithKeyValues:data];
        weakSelf.candyTaskDatasourceArray = [NSMutableArray arrayWithArray:result.data];
        complete(result , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}

- (void)getCandyEquities:(CompleteBlock)complete{
    WS(weakSelf);
    [self.candy_equity_list_request getDataSusscess:^(id DAO, id data) {
        
        CandyEquityResult *result = [CandyEquityResult mj_objectWithKeyValues:data];
        weakSelf.candEquityDatasourceArray = [NSMutableArray arrayWithArray:result.data];
        complete(result , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}



@end
