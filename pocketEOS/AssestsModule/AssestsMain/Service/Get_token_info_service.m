//
//  Get_token_info_service.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_token_info_service.h"
#import "GetTokenInfoResult.h"
#import "TokenInfo.h"

@implementation Get_token_info_service

- (Get_token_info_request *)get_token_info_request{
    if (!_get_token_info_request) {
        _get_token_info_request = [[Get_token_info_request alloc] init];
    }
    return _get_token_info_request;
}

- (void)get_token_info:(CompleteBlock)complete{
    WS(weakSelf);
    [self.get_token_info_request postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        GetTokenInfoResult *result = [GetTokenInfoResult mj_objectWithKeyValues:data];
        [weakSelf.responseArray addObjectsFromArray:result.data];
        [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        complete(result, YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}

@end
