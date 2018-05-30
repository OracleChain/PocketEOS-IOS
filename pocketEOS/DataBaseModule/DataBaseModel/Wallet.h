//
//  Wallet.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 wallet model
 */
@class FMResultSet;
@interface Wallet : NSObject

@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *wallet_name;
@property(nonatomic, strong) NSString *wallet_uid;
@property(nonatomic, strong) NSString *wallet_phone;

/**
 对密码进行 sha256 
 */
@property(nonatomic, strong) NSString *wallet_shapwd;
@property(nonatomic, strong) NSString *wallet_img;
@property(nonatomic, strong) NSString *wallet_main_account;
@property(nonatomic, strong) NSString *wallet_main_account_img;
@property(nonatomic, strong) NSString *wallet_qq;
@property(nonatomic, strong) NSString *wallet_weixin;
@property(nonatomic, strong) NSString *password_check;
@property(nonatomic, strong) NSString *account_info_table_name;

// 所有的账号
@property(nonatomic, strong) NSMutableArray *account_info;

@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *wallet_avatar;

- (void)parseFromSet:(FMResultSet *)resultSet;

@end
