//
//  RichListService.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/1.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

/**
 *  新闻缓存表
 */
#define RICHLIST_CACHE_TABLE @"richlist_cache_table"

#import "RichListService.h"
#import "RichListResult.h"
#import "Follow.h"

@interface RichListService()

/**
 用来临时存放索引数组
 */
@property(nonatomic, strong) NSMutableArray *tempArr;

@end


@implementation RichListService


- (RichListRequest *)richListRequest{
    if (!_richListRequest) {
        _richListRequest = [[RichListRequest alloc] init];
    }
    return _richListRequest;
}

- (NSMutableDictionary *)dataDictionary{
    if (!_dataDictionary) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}

- (NSMutableArray *)keysArray{
    if (!_keysArray) {
        _keysArray = [[NSMutableArray alloc] init];
    }
    return _keysArray;
}

- (NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = [[NSMutableArray alloc] init];
    }
    return _tempArr;
}

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [self.keysArray removeAllObjects];
    [self.tempArr removeAllObjects];
    [self.dataDictionary removeAllObjects];
    CacheTableManager *mgr = [[CacheTableManager alloc] initWithCacheTableName:RICHLIST_CACHE_TABLE];
    [self.richListRequest postDataSuccess:^(id DAO, id data) {
        RichListResult *result = [RichListResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [mgr clearAllCacheTableWithCacheTableName:RICHLIST_CACHE_TABLE];
            FMDatabase *database = [mgr openLocalDatabase];
            BOOL isOpen = [database open];
            if (isOpen) {
                for (NSDictionary *dic in data[@"data"]) {
                    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL result = [database executeUpdate:@"INSERT INTO richlist_cache_table (cache_data,cache_key) VALUES (?,?)",  cacheData,VALIDATE_STRING(dic[@"displayName"])];
                    if (result) {
                        NSLog(@" insert richlist_cache_table success");
                    }else{
                        NSLog(@" insert richlist_cache_table faild");
                    }
                    
                }
            }
            [database close];
            
            // 关注的账号或钱包
            NSMutableArray *followsArr = result.data;
            [weakSelf handleDataWithResultArr:followsArr];
            
        }
        if (self.keysArray.count > 0) {
            complete(weakSelf , YES);            
        }
        
    } failure:^(id DAO, NSError *error) {
        NSArray *localRichlistCacheArr = [mgr selectAllCacheItemWithCacheTableName:RICHLIST_CACHE_TABLE];
        [weakSelf handleDataWithResultArr:localRichlistCacheArr];
        if (self.keysArray.count > 0) {
            complete(nil , NO);
        }
    }];
}

- (void)handleDataWithResultArr:(NSArray *)resultArray{
    // 获取 key 对应的数据源
    NSMutableArray *itemArray = [NSMutableArray array];
    
    for (NSDictionary *dic in resultArray) {
        Follow *model = [Follow mj_objectWithKeyValues:dic];
        // 生成索引数组
        NSString *firstLetter = [NSString firstCharactorWithString: VALIDATE_STRING(model.displayName) ];
        NSString *regex = @"[A-Z]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject: firstLetter]) {
            // 是字母 A - Z
            if (![self.tempArr containsObject: firstLetter]) {
                [self.tempArr addObject:firstLetter];
            }
            itemArray = [self.dataDictionary objectForKey:firstLetter];
            if (IsNilOrNull(itemArray)) {
                itemArray = [NSMutableArray array];
            }
            [itemArray addObject:model];
            [self.dataDictionary setObject:itemArray forKey:firstLetter];
        }else {
            // 其他非字母 A - Z 开头的联系人
            if (![self.tempArr containsObject:@"#"]) {
                [self.tempArr addObject: @"#"];
            }
            itemArray = [self.dataDictionary objectForKey:@"#"];
            if (IsNilOrNull(itemArray)) {
                itemArray = [NSMutableArray array];
            }
            [itemArray addObject:model];
            [self.dataDictionary setObject:itemArray forKey:@"#"];
        }
        
    }
    // 对索引数组进行排序
    NSArray *sortArr = [self.tempArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedArr = [NSMutableArray arrayWithArray: sortArr];
    if ([sortedArr containsObject:@"#"]) {
        if (sortedArr.count > 0) {
            [sortedArr removeObjectAtIndex:0];
        }
        [sortedArr addObject:@"#"];
    }
    
    [self.keysArray addObjectsFromArray:sortedArr];
    
}

@end
                   
