//
//  AccountsTableManager.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AccountsTableManager.h"


@implementation AccountsTableManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        FMDatabase *database = [self openLocalDatabase];
        if ([database open]) {
            Wallet *wallet = CURRENT_WALLET;
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY, account_name TEXT ,account_img TEXT, account_active_public_key TEXT,  account_owner_public_key TEXT, account_active_private_key TEXT,account_owner_private_key TEXT, is_privacy_policy TEXT, is_main_account TEXT)", wallet.account_info_table_name];
            
            BOOL isSuccess = [database executeUpdate:sql];
            if (isSuccess) {
                
            }
            [database close];
        }
    }
    return self;
}

+ (instancetype)accountTable{
    return [[self alloc] init];
}

- (FMDatabase *)openLocalDatabase{
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString: [NSString stringWithFormat:@"/%@.db",  LOCAL_DATABASE ]];
    return [FMDatabase databaseWithPath:databasePath];
}


- (NSMutableArray *)selectAccountTable{
    FMDatabase *database = [self openLocalDatabase];
    NSMutableArray *arr = [NSMutableArray array];
    BOOL isOpen = [database open];
    if (isOpen) {
        Wallet *wallet = CURRENT_WALLET;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", wallet.account_info_table_name];
        FMResultSet *resultSet = [database executeQuery:sql];
        while([resultSet next]) {
            AccountInfo *account = [[AccountInfo alloc] init];
            [account parseFromSet:resultSet];
            [arr addObject:account];
        }
        [database close];
        return arr;
    }
    return nil;
}

- (AccountInfo *)selectAccountTableWithAccountName:(NSString *)accountName{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        Wallet *wallet = CURRENT_WALLET;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE account_name = '%@'", wallet.account_info_table_name, accountName];
        FMResultSet *resultSet = [database executeQuery:sql];
        while([resultSet next]) {
            AccountInfo *account = [[AccountInfo alloc] init];
            [account parseFromSet:resultSet];
            return account;
        }
        [database close];
    }
    return nil;
}

- (NSArray *)selectAllNativeAccountName{
    FMDatabase *database = [self openLocalDatabase];
    NSMutableArray *arr = [NSMutableArray array];
    BOOL isOpen = [database open];
    if (isOpen) {
        Wallet *wallet = CURRENT_WALLET;
        FMResultSet *resultSet = [database executeQuery: [NSString stringWithFormat: @"SELECT account_name FROM '%@'" , wallet.account_info_table_name ]];
        while([resultSet next]) {
            [arr addObject:[resultSet.resultDictionary objectForKey:@"account_name"]];
        }
        [database close];
        return arr;
    }
    return nil;
}


- (BOOL)addRecord:(AccountInfo *)model{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        Wallet *wallet = CURRENT_WALLET;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (account_name, account_img, account_active_public_key, account_owner_public_key, account_active_private_key,account_owner_private_key, is_privacy_policy, is_main_account) VALUES ('%@', '%@', '%@','%@', '%@','%@' ,'%@','%@')", wallet.account_info_table_name, model.account_name, model.account_img, model.account_active_public_key , model.account_owner_public_key ,  model.account_active_private_key,model.account_owner_private_key, model.is_privacy_policy, model.is_main_account];
        BOOL result = [database executeUpdate:sql];
        if (result) {
            NSLog(@"添加账号成功");
        }
        [database close];
        return result;
    }
    return NO;
}

- (BOOL)deleteRecord:(NSString *)account_name{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        Wallet *wallet = CURRENT_WALLET;
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE account_name = ('%@')", wallet.account_info_table_name , account_name];
        BOOL result = [database executeUpdate:sql];
        if (result) {
            
        }
        [database close];
        return result;
    }
    return NO;
}

/**
 执行 sql 语句
 */
- (BOOL)executeUpdate:(NSString *)sqlString{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        NSString *sql = sqlString;
        BOOL result = [database executeUpdate:sql];
        if (result) {
            
        }
        [database close];
        return result;
    }
    return NO;
}


@end
