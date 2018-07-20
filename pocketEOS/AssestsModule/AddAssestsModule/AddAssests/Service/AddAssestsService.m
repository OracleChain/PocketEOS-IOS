//
//  AddAssestsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AddAssestsService.h"
#import "RecommandTokenResult.h"
#import "RecommandTokensResult.h"
#import "RecommandToken.h"

@interface AddAssestsService()
@property(nonatomic , assign) NSUInteger page;
@end


@implementation AddAssestsService

- (Get_recommand_token_request *)get_recommand_token_request{
    if (!_get_recommand_token_request) {
        _get_recommand_token_request = [[Get_recommand_token_request alloc] init];
    }
    return _get_recommand_token_request;
}

- (Search_token_request *)search_token_request{
    if (!_search_token_request) {
        _search_token_request = [[Search_token_request alloc] init];
    }
    return _search_token_request;
}

- (NSMutableArray *)searchTokenResultDataArray{
    if (!_searchTokenResultDataArray) {
        _searchTokenResultDataArray = [[NSMutableArray alloc] init];
    }
    return _searchTokenResultDataArray;
}

- (NSMutableArray *)followAssetIdsDataArray{
    if (!_followAssetIdsDataArray) {
        _followAssetIdsDataArray = [[NSMutableArray alloc] init];
    }
    return _followAssetIdsDataArray;
}


-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    _page = 0;
    self.get_recommand_token_request.offset = @(_page);
    self.get_recommand_token_request.size = @(PER_PAGE_SIZE_15);
    [self.get_recommand_token_request postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        [weakSelf.followAssetIdsDataArray removeAllObjects];
        
        RecommandTokenResult *result = [RecommandTokenResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            RecommandTokensResult *recommandTokensResult = [RecommandTokensResult mj_objectWithKeyValues:result.data];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(recommandTokensResult.assetCategoryList)];
            
            [weakSelf.followAssetIdsDataArray addObjectsFromArray:VALIDATE_ARRAY(recommandTokensResult.followAssetIds)];
            
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
        }
        
        complete(@(result.assetCategoryList.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)buildNextPageDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    _page +=1;
    self.get_recommand_token_request.offset = @(_page);
    self.get_recommand_token_request.size = @(PER_PAGE_SIZE_15);
    [self.get_recommand_token_request postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.responseArray removeAllObjects];
        RecommandTokenResult *result = [RecommandTokenResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            RecommandTokensResult *recommandTokensResult = [RecommandTokensResult mj_objectWithKeyValues:result.data];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(recommandTokensResult.assetCategoryList)];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        }
        
        complete(@(result.assetCategoryList.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}



- (void)search_token:(CompleteBlock)complete{
    WS(weakSelf);
    [self.search_token_request getDataSusscess:^(id DAO, id data) {
        [weakSelf.searchTokenResultDataArray removeAllObjects];
        RecommandTokenResult *result = [RecommandTokenResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            RecommandTokensResult *recommandTokensResult = [RecommandTokensResult mj_objectWithKeyValues:result.data];
            weakSelf.searchTokenResultDataArray = [NSMutableArray arrayWithArray:recommandTokensResult.assetCategoryList];
        }
        
        complete(weakSelf.searchTokenResultDataArray , YES);
    } failure:^(id DAO, NSError *error) {
       complete(nil, NO);
    }];
}

@end
