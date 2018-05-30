//
//  Wallet.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "Wallet.h"

@implementation Wallet

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"wallet_uid" : @"uid",
             @"wallet_name" : @"walletName",
             @"wallet_avatar" : @"avatar"
             };
}

- (void)parseFromSet:(FMResultSet *)resultSet{
    self.ID = VALIDATE_STRING([resultSet stringForColumn:@"ID"]);
    self.wallet_name = VALIDATE_STRING([resultSet stringForColumn:@"wallet_name"]);
    self.wallet_uid = VALIDATE_STRING([resultSet stringForColumn:@"wallet_uid"]);
    self.wallet_img = VALIDATE_STRING([resultSet stringForColumn:@"wallet_img"]);
    self.wallet_main_account = VALIDATE_STRING([resultSet stringForColumn:@"wallet_main_account"]);
    self.wallet_phone = VALIDATE_STRING([resultSet stringForColumn:@"wallet_phone"]);
    self.wallet_qq = VALIDATE_STRING([resultSet stringForColumn:@"wallet_qq"]);
    self.wallet_weixin = VALIDATE_STRING([resultSet stringForColumn:@"wallet_weixin"]);
    self.wallet_shapwd = VALIDATE_STRING([resultSet stringForColumn:@"wallet_shapwd"]);
    self.password_check = VALIDATE_STRING([resultSet stringForColumn:@"password_check"]);
    self.account_info_table_name = VALIDATE_STRING([resultSet stringForColumn:@"account_info_table_name"]);
}
@end
