//
//  NewsBannerService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/12.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

/**
 *  新闻banner缓存表
 */
#define NEWS_BANNER_CACHE_TABLE @"news_banner_cache_table"

#import "NewsBannerService.h"
#import "NewsResult.h"
#import "News.h"

@implementation NewsBannerService

- (NewsRequest *)newsRequest{
    if (!_newsRequest) {
        _newsRequest = [[NewsRequest alloc] init];
    }
    return _newsRequest;
}

- (NSMutableArray *)imageURLStringsGroup{
    if (!_imageURLStringsGroup) {
        _imageURLStringsGroup = [[NSMutableArray alloc] init];
    }
    return _imageURLStringsGroup;
}

- (void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.newsRequest.size = @(7);
    self.newsRequest.scope = @(1);
    self.newsRequest.assetCategoryId = @(0);
    [weakSelf.responseArray removeAllObjects];
    [weakSelf.dataSourceArray removeAllObjects];
    [weakSelf.imageURLStringsGroup removeAllObjects];
    
    CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:NEWS_BANNER_CACHE_TABLE];
    [self.newsRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        NewsResult *result = [NewsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            
            [mgr clearAllCacheTableWithCacheTableName:NEWS_BANNER_CACHE_TABLE];
            FMDatabase *database = [mgr openLocalDatabase];
            BOOL isOpen = [database open];
            if (isOpen) {
                for (News *news in result.data) {
                    
                    [weakSelf.imageURLStringsGroup addObject:VALIDATE_STRING(news.imageUrl)];
                    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:news.mj_JSONObject];
                    BOOL result = [database executeUpdate:@"INSERT INTO news_banner_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_STRING(news.newsUrl)];
                    if (result) {
                        NSLog(@" insert news_banner_cache_table success");
                    }else{
                        NSLog(@" insert news_banner_cache_table faild");
                    }
                }
            }
            [database close];
        }
        complete(result.code , YES);
        
    } failure:^(id DAO, NSError *error) {
        NSArray *localNewsCacheArr = [mgr selectAllCacheItemWithCacheTableName:NEWS_BANNER_CACHE_TABLE];
        for (NSDictionary *dic in localNewsCacheArr) {
            News *news = [News mj_objectWithKeyValues:dic];
            [weakSelf.dataSourceArray addObject:news];
            [weakSelf.imageURLStringsGroup addObject:VALIDATE_STRING(news.imageUrl)];
        }
        complete(nil, NO);
    }];
}


@end
