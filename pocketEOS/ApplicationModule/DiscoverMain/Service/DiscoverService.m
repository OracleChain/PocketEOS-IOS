//
//  DiscoverService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DiscoverService.h"
#import "Get_recommend_dapp_result.h"
#import "Discover_Category_config_result.h"
#import "DappListResult.h"

@implementation DiscoverService


- (Get_recommend_dapp_request *)get_recommend_dapp_request{
    if (!_get_recommend_dapp_request) {
        _get_recommend_dapp_request = [[Get_recommend_dapp_request alloc] init];
    }
    return _get_recommend_dapp_request;
}

- (Get_category_config_request *)get_category_config_request{
    if (!_get_category_config_request) {
        _get_category_config_request = [[Get_category_config_request alloc] init];
    }
    return _get_category_config_request;
}

- (Get_dapp_by_config_id_request *)get_dapp_by_config_id_request{
    if (!_get_dapp_by_config_id_request) {
        _get_dapp_by_config_id_request = [[Get_dapp_by_config_id_request alloc] init];
    }
    return _get_dapp_by_config_id_request;
}



- (NSMutableArray *)category_configDataSourceArray{
    if (!_category_configDataSourceArray) {
        _category_configDataSourceArray = [[NSMutableArray alloc] init];
    }
    return _category_configDataSourceArray;
}

- (void)get_recommend_dapp:(CompleteBlock)complete{

    [self.get_recommend_dapp_request getDataSusscess:^(id DAO, id data) {
        Get_recommend_dapp_result *result = [Get_recommend_dapp_result mj_objectWithKeyValues:data];
        complete(result, YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)get_category_config:(CompleteBlock)complete{
    WS(weakSelf);
    [self.category_configDataSourceArray removeAllObjects];
    [self.get_category_config_request getDataSusscess:^(id DAO, id data) {
        Discover_Category_config_result *result = [Discover_Category_config_result mj_objectWithKeyValues:data];
        [weakSelf.category_configDataSourceArray addObjectsFromArray:result.data];
        complete(result, YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)get_dapp_by_config_id:(CompleteBlock)complete{
//    WS(weakSelf);
//    [self.get_dapp_by_config_id_request getDataSusscess:^(id DAO, id data) {
//
//    } failure:^(id DAO, NSError *error) {
//
//    }];
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [self.dataSourceArray removeAllObjects];
    [self.get_dapp_by_config_id_request getDataSusscess:^(id DAO, id data) {
        
        DappListResult *result = [DappListResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.dataSourceArray addObjectsFromArray:result.data];
        }
        complete(@(result.data.count) , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}


@end
