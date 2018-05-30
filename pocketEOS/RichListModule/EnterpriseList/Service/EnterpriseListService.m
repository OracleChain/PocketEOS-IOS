//
//  EnterpriseListService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "EnterpriseListService.h"
#import "EnterpriseListRequest.h"
#import "RichListResult.h"

@implementation EnterpriseListService

- (EnterpriseListRequest *)enterpriseListRequest{
    if (!_enterpriseListRequest) {
        _enterpriseListRequest = [[EnterpriseListRequest alloc] init];
    }
    return _enterpriseListRequest;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.enterpriseListRequest.size = @(PER_PAGE_SIZE_15);
    self.enterpriseListRequest.offset = @(0);
    [self.enterpriseListRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
         RichListResult *result = [RichListResult mj_objectWithKeyValues:data];
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
    self.enterpriseListRequest.size = @(PER_PAGE_SIZE_15);
    self.enterpriseListRequest.offset = @(self.dataSourceArray.count);
    [self.enterpriseListRequest postDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        
         RichListResult *result = [RichListResult mj_objectWithKeyValues:data];
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
