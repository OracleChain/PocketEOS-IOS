//
//  CacheTableManager.h
//  pocketEOS
//
//  Created by oraclechain on 12/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CacheTableManager : NSObject

- (FMDatabase *)openLocalDatabase;

/**
 initWithCacheTableName

 @param cache_table_name cache_table_name
 @return instancetype
 */
- (instancetype)initWithCacheTableName:(NSString *)cache_table_name;




/**
 selectCache
 
 @param cacheKey cacheKey
 @param cache_table_name cache_table_name
 @return cache
 */
- (id)selectCacheItemWithCacheKey:(NSString *)cacheKey andCacheTableName:(NSString *)cache_table_name;


/**
 selectAllCache
 
 @param cache_table_name cache_table_name
 @return AllCache
 */
- (NSArray *)selectAllCacheItemWithCacheTableName:(NSString *)cache_table_name;

/**
 clearAllCacheTable
 */
- (void)clearAllCacheTableWithCacheTableName:(NSString *)cache_table_name;
@end
