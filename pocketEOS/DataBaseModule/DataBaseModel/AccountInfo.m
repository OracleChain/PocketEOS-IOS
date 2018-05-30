//
//  AccountInfo.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo
- (void)parseFromSet:(FMResultSet *)resultSet{
    
    self.account_name = VALIDATE_STRING([resultSet stringForColumn:@"account_name"]);
    self.account_img = VALIDATE_STRING([resultSet stringForColumn:@"account_img"]);
    self.account_active_public_key = VALIDATE_STRING([resultSet stringForColumn:@"account_active_public_key"]);
    self.account_owner_public_key = VALIDATE_STRING([resultSet stringForColumn:@"account_owner_public_key"]);
    
    self.account_active_private_key = VALIDATE_STRING([resultSet stringForColumn:@"account_active_private_key"]);
    self.account_owner_private_key = VALIDATE_STRING([resultSet stringForColumn:@"account_owner_private_key"]);
    
    self.is_privacy_policy = [resultSet stringForColumn:@"is_privacy_policy"];
    self.is_main_account = [resultSet stringForColumn:@"is_main_account"];
    
}
@end
