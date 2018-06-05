//
//  ApplicationService.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

/**
 *  header缓存表
 */
#define APPLICATION_HEADER_CACHE_TABLE @"application_header_cache_table"

/**
 *  应用body缓存表
 */
#define APPLICATION_BODY_CACHE_TABLE @"application_body_cache_table"


#import "ApplicationService.h"
#import "ApplicationsResult.h"
#import "Application.h"
#import "EnterpriseResult.h"
#import "Enterprise.h"

@implementation ApplicationService

- (ApplicationModuleHeaderRequest *)applicationModuleHeaderRequest{
    if (!_applicationModuleHeaderRequest) {
        _applicationModuleHeaderRequest = [[ApplicationModuleHeaderRequest alloc] init];
    }
    return _applicationModuleHeaderRequest;
}

- (ApplicationModuleBodyRequest *)applicationModuleBodyRequest{
    if (!_applicationModuleBodyRequest) {
        _applicationModuleBodyRequest = [[ApplicationModuleBodyRequest alloc] init];
    }
    return _applicationModuleBodyRequest;
}

- (NSMutableArray *)bannerDataArray{
    if (!_bannerDataArray) {
        _bannerDataArray = [[NSMutableArray alloc] init];
    }
    return _bannerDataArray;
}
- (NSMutableArray *)imageURLStringsGroup{
    if (!_imageURLStringsGroup) {
        _imageURLStringsGroup = [[NSMutableArray alloc] init];
    }
    return _imageURLStringsGroup;
}
- (NSMutableArray *)top4DataArray{
    if (!_top4DataArray) {
        _top4DataArray = [[NSMutableArray alloc] init];
    }
    return _top4DataArray;
}
- (NSMutableArray *)starDataArray{
    if (!_starDataArray) {
        _starDataArray = [[NSMutableArray alloc] init];
    }
    return _starDataArray;
}

- (NSMutableArray *)listDataArray{
    if (!_listDataArray) {
        _listDataArray = [[NSMutableArray alloc] init];
    }
    return _listDataArray;
}



- (void)applicationModuleHeaderRequest:(CompleteBlock)complete{
    WS(weakSelf);
    CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:APPLICATION_HEADER_CACHE_TABLE];
    [self.applicationModuleHeaderRequest getDataSusscess:^(id DAO, id data) {
        
        EnterpriseResult *result = [EnterpriseResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            
            NSMutableArray *resultArr = result.data;
            if (resultArr.count > 0 && resultArr.count <= 3) {
                // 添加轮播图数据
                [weakSelf.imageURLStringsGroup removeAllObjects];
                [weakSelf.bannerDataArray removeAllObjects];
                
                [mgr clearAllCacheTableWithCacheTableName:APPLICATION_HEADER_CACHE_TABLE];
                FMDatabase *database = [mgr openLocalDatabase];
                BOOL isOpen = [database open];
                if (isOpen) {
                    for (int i = 0 ; i < resultArr.count; i++) {
                        Enterprise *model = resultArr[i];
                        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:model.mj_JSONObject];
                        BOOL result = [database executeUpdate:@"INSERT INTO application_header_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_NUMBER(model.enterprise_id)];
                        if (result) {
                            NSLog(@" insert application_header_cache_table success");
                        }else{
                            NSLog(@" insert application_header_cache_table faild");
                        }
                        [weakSelf.imageURLStringsGroup addObject :VALIDATE_STRING(model.publicImage) ];
                        [weakSelf.bannerDataArray addObject:model];
                        
                    }
                }
                [database close];
            }else if(resultArr.count >= 4 && resultArr.count <=7 ){
            // 添加 top4 应用数据
            weakSelf.top4DataArray = (NSMutableArray *)[resultArr subarrayWithRange:NSMakeRange(4, resultArr.count - 4)];
            }
    }
        complete(weakSelf , YES);
    } failure:^(id DAO, NSError *error) {
        NSArray *localApplicationBannerCacheArr = [mgr selectAllCacheItemWithCacheTableName:APPLICATION_HEADER_CACHE_TABLE];
        if (localApplicationBannerCacheArr.count > 0 && localApplicationBannerCacheArr.count <= 3) {
            for (NSDictionary *dic in localApplicationBannerCacheArr) {
                Enterprise *model = [Enterprise mj_objectWithKeyValues:dic];
                [weakSelf.bannerDataArray addObject:model];
                [weakSelf.imageURLStringsGroup addObject:VALIDATE_STRING(model.publicImage)];
            }
        }else if(localApplicationBannerCacheArr.count >= 4 && localApplicationBannerCacheArr.count <=7 ){
            // 添加 top4 应用数据
            weakSelf.top4DataArray = (NSMutableArray *)[localApplicationBannerCacheArr subarrayWithRange:NSMakeRange(4, localApplicationBannerCacheArr.count - 4)];
        }
        complete(nil , NO);
    }];
}

- (void)applicationModuleBodyRequest:(CompleteBlock)complete{
    WS(weakSelf);
     CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:APPLICATION_BODY_CACHE_TABLE];
    [self.applicationModuleBodyRequest getDataSusscess:^(id DAO, id data) {
        
        ApplicationsResult *result = [ApplicationsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            NSMutableArray *resultArr = result.data;
            [mgr clearAllCacheTableWithCacheTableName:APPLICATION_BODY_CACHE_TABLE];
            FMDatabase *database = [mgr openLocalDatabase];
            BOOL isOpen = [database open];
            if (isOpen) {
                for (Application *model in resultArr) {
                    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:model.mj_JSONObject];
                    BOOL result = [database executeUpdate:@"INSERT INTO application_body_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_NUMBER(model.application_id)];
                    if (result) {
                        NSLog(@" insert application_body_cache_table success");
                    }else{
                        NSLog(@" insert application_body_cache_table faild");
                    }
                }
                
            }
            
            
            if (VALIDATE_ARRAY(result.data)) {
                if (resultArr.count > 0 && resultArr.count < 2 ) {
                    weakSelf.starDataArray = (NSMutableArray *)[resultArr subarrayWithRange:(NSMakeRange(0, 1))];
                }else if (resultArr.count > 1 ){
                    weakSelf.starDataArray = (NSMutableArray *)[resultArr subarrayWithRange:(NSMakeRange(0, 1))];
                    weakSelf.listDataArray = (NSMutableArray *)[resultArr subarrayWithRange:NSMakeRange(1, resultArr.count - 1)];
                    
                }
            }
            
        }
        
        complete(weakSelf , YES);
        
    } failure:^(id DAO, NSError *error) {
        NSArray *localApplicationBodyCacheArr = [mgr selectAllCacheItemWithCacheTableName:APPLICATION_BODY_CACHE_TABLE];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in localApplicationBodyCacheArr) {
            Application *model = [Application mj_objectWithKeyValues:dic];
            [modelArr addObject:model];
        }
        if (VALIDATE_ARRAY(modelArr)) {
            if (modelArr.count >= 1) {
                weakSelf.starDataArray = (NSMutableArray *)[modelArr subarrayWithRange:(NSMakeRange(0, 1))];
            }else if (modelArr.count >= 2){
                weakSelf.starDataArray = (NSMutableArray *)[modelArr subarrayWithRange:(NSMakeRange(0, 1))];
                weakSelf.listDataArray = (NSMutableArray *)[modelArr subarrayWithRange:NSMakeRange(1, modelArr.count - 1)];
            }
        }
        
        complete(nil , NO);
    }];
}


@end
