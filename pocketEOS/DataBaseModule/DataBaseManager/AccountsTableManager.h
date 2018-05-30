//
//  AccountsTableManager.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"

@interface AccountsTableManager : NSObject
+ (instancetype)accountTable;
- (BOOL)addRecord:(AccountInfo *)model;
- (BOOL)deleteRecord:(NSString *)account_name;
- (NSMutableArray *)selectAccountTable;
- (AccountInfo *)selectAccountTableWithAccountName:(NSString *)accountName;
- (NSArray *)selectAllNativeAccountName;
/**
 执行 sql 语句
 执行更新：
 
 在FMDB中，除查询以外的所有操作，都称为“更新”
 
 create、drop、insert、update、delete等
 
 使用executeUpdate:方法执行更新
 
 
 */
- (BOOL)executeUpdate:(NSString *)sqlString;

@end
