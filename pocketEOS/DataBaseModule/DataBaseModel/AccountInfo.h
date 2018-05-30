//
//  AccountInfo.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

/**
 本地数据库存储的 account
 */
@interface AccountInfo : NSObject

@property(nonatomic, copy) NSString *account_name;

@property(nonatomic, strong) NSString *account_img;

@property(nonatomic, copy) NSString *account_active_public_key;

@property(nonatomic, copy) NSString *account_owner_public_key;

@property(nonatomic, copy) NSString *account_active_private_key;

@property(nonatomic, copy) NSString *account_owner_private_key;


// 0 表示 没有隐私保护, 1 表示有隐私保护
@property(nonatomic, copy) NSString *is_privacy_policy;

@property(nonatomic, copy) NSString *is_main_account;

- (void)parseFromSet:(FMResultSet *)set;


@property(nonatomic, assign) BOOL selected;

@end
