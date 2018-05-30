//
//  NewsService.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//
/**
 *  新闻缓存表
 */
#define NEWS_CACHE_TABLE @"news_cache_table"

#import "NewsService.h"
#import "NewsResult.h"
#import "News.h"
#import "Assest.h"

@implementation NewsService

- (NewsRequest *)newsRequest{
    if (!_newsRequest) {
        _newsRequest = [[NewsRequest alloc] init];
    }
    return _newsRequest;
}

- (GetAssetCategoryAllRequest *)getAssetCategoryAllRequest{
    if (!_getAssetCategoryAllRequest) {
        _getAssetCategoryAllRequest = [[GetAssetCategoryAllRequest alloc] init];
    }
    return _getAssetCategoryAllRequest;
}
- (NSMutableArray *)allAssetsArray{
    if (!_allAssetsArray) {
        _allAssetsArray = [[NSMutableArray alloc] init];
    }
    return _allAssetsArray;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.newsRequest.size = @(PER_PAGE_SIZE_15);
    self.newsRequest.offset = @(0);
    self.newsRequest.scope = @(2);// 可选，新闻分类，1表示banner新闻，2表示列表新闻，3待定
    CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:NEWS_CACHE_TABLE];
    [self.newsRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        NewsResult *result = [NewsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [mgr clearAllCacheTableWithCacheTableName:NEWS_CACHE_TABLE];
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            
            FMDatabase *database = [mgr openLocalDatabase];
            BOOL isOpen = [database open];
            if (isOpen) {
            for (News *news in weakSelf.responseArray) {
                    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:news.mj_JSONObject];
                    BOOL result = [database executeUpdate:@"INSERT INTO news_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_STRING(news.newsUrl)];
                    if (result) {
                        NSLog(@" insert news_cache_table success");
                    }else{
                        NSLog(@" insert news_cache_table faild");
                    }
                }
            }
            [database close];
        }
        complete(@(result.data.count) , YES);

    } failure:^(id DAO, NSError *error) {
        
        NSArray *localNewsCacheArr = [mgr selectAllCacheItemWithCacheTableName:NEWS_CACHE_TABLE];
        for (NSDictionary *dic in localNewsCacheArr) {
            News *news = [News mj_objectWithKeyValues:dic];
            [weakSelf.dataSourceArray addObject:news];
        }
        complete(nil, NO);
    }];
}

- (void)buildNextPageDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.newsRequest.size = @(PER_PAGE_SIZE_15);
    self.newsRequest.offset = @(self.dataSourceArray.count);
    self.newsRequest.scope = @(2);
    CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:NEWS_CACHE_TABLE];
    [self.newsRequest postDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        
        NewsResult *result = [NewsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            FMDatabase *database = [mgr openLocalDatabase];
            BOOL isOpen = [database open];
            if (isOpen) {
                for (News *news in weakSelf.responseArray) {
                    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:news.mj_JSONObject];
                    BOOL result = [database executeUpdate:@"INSERT INTO news_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_STRING(news.newsUrl)];
                    if (result) {
                        NSLog(@" insert news_cache_table success");
                    }else{
                        NSLog(@" insert news_cache_table faild");
                    }
                }
            }
            [database close];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        }
        complete(@(result.data.count)  , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)GetAssetCategoryAllRequest:(CompleteBlock)complete{
     WS(weakSelf);
    [self.getAssetCategoryAllRequest getDataSusscess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            weakSelf.allAssetsArray = [Assest mj_objectArrayWithKeyValuesArray:data[@"data"]];
            complete(weakSelf.allAssetsArray , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
    
}

@end
