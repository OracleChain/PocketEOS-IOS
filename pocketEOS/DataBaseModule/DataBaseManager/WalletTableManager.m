//
//  WalletTableManager.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "WalletTableManager.h"


@implementation WalletTableManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        FMDatabase *database = [self openLocalDatabase];
        if ([database open]) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY, wallet_name TEXT NOT NULL ,wallet_uid TEXT NOT NULL, wallet_img TEXT, wallet_main_account TEXT,wallet_main_account_img TEXT, wallet_phone TEXT NOT NULL, wallet_shapwd TEXT,wallet_qq TEXT, wallet_weixin TEXT, password_check TEXT, account_info_table_name     TEXT )", WALLET_TABLE];
            BOOL isSuccess = [database executeUpdate:sql];
            if (isSuccess) {
            }
            [database close];
        }
    }
    return self;
}

+ (instancetype)walletTable{
    return [[self alloc] init];
}

- (FMDatabase *)openLocalDatabase{
   NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString: [NSString stringWithFormat:@"/%@.db",  LOCAL_DATABASE ]];
    NSLog(@"数据库路径:%@", databasePath);
    return [FMDatabase databaseWithPath:databasePath];
}

- (BOOL)addRecord:(Wallet *)model{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (wallet_name , wallet_uid, wallet_img, wallet_main_account ,wallet_main_account_img, wallet_phone , wallet_shapwd , wallet_qq, wallet_weixin, password_check , account_info_table_name) VALUES  ('%@','%@' ,'%@','%@','%@','%@','%@','%@','%@','%@','%@')", WALLET_TABLE, model.wallet_name,  model.wallet_uid, model.wallet_img , model.wallet_main_account , model.wallet_main_account_img, model.wallet_phone , model.wallet_shapwd, model.wallet_qq , model.wallet_weixin , model.password_check, model.account_info_table_name ];
        BOOL result = [database executeUpdate:sql];
        if (result) {
            NSLog(@"添加钱包成功!");
        }
        [database close];
        return result;
    }
    return NO;
}

- (BOOL)deleteRecord:(NSString *)wallet_uid{
    FMDatabase *database = [self openLocalDatabase];
    BOOL isOpen = [database open];
    if (isOpen) {
        NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE wallet_uid = ('%@')" , WALLET_TABLE, wallet_uid];
        BOOL result = [database executeUpdate:sql];
        if (result) {
            NSLog(@"删除钱包成功!");
        }
        [database close];
        return result;
    }
    return NO;
}

/**
 allLocalWallet
 
 @return allLocalWallet
 */
- (NSMutableArray<Wallet *> *)selectAllLocalWallet{
    FMDatabase *database = [self openLocalDatabase];
    NSMutableArray *walletArr = [NSMutableArray array];
    BOOL isOpen = [database open];
    if (isOpen) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'", WALLET_TABLE];
        FMResultSet *resultSet = [database executeQuery:sql];
        while ([resultSet next]) {
            Wallet *wallet = [[Wallet alloc] init];
            [wallet parseFromSet:resultSet];
            if (wallet) {
                [walletArr addObject:wallet];
            }
        }
        [database close];
        return walletArr;
    }
    return nil;
}



/**
 currentWallet

 @return currentWallet
 */
- (NSMutableArray<Wallet *> *)selectCurrentWallet{
    FMDatabase *database = [self openLocalDatabase];
    NSMutableArray *walletArr = [NSMutableArray array];
    BOOL isOpen = [database open];
    if (isOpen) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE wallet_uid = '%@'", WALLET_TABLE, CURRENT_WALLET_UID];
        FMResultSet *resultSet = [database executeQuery:sql];
        while ([resultSet next]) {
            Wallet *wallet = [[Wallet alloc] init];
            [wallet parseFromSet:resultSet];
            if (wallet) {
                [walletArr addObject:wallet];
            }
        }
        [database close];
        return walletArr;
    }
    return nil;
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
