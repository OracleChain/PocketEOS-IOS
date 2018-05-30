//
//  WalletTableManager.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

@interface WalletTableManager : NSObject


+ (instancetype)walletTable;

/**
 添加记录
 */
- (BOOL)addRecord:(Wallet *)model;

/**
 删除钱包

 @param wallet_uid wallet_uid
 */
- (BOOL)deleteRecord:(NSString *)wallet_uid;


/**
 allLocalWallet
 
 @return allLocalWallet
 */
- (NSMutableArray<Wallet *> *)selectAllLocalWallet;


/**
 查询当前钱包信息
 */
- (NSMutableArray<Wallet *> *)selectCurrentWallet;

/**
 执行 sql 语句
 执行更新：
 
 在FMDB中，除查询以外的所有操作，都称为“更新”
 
 create、drop、insert、update、delete等
 
 使用executeUpdate:方法执行更新
 

 */
- (BOOL)executeUpdate:(NSString *)sqlString;

@end
