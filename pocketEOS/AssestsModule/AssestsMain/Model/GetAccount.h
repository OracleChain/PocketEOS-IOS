//
//  GetAccount.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/6.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAccount : NSObject

@property(nonatomic, strong) NSString *staked_balance;
@property(nonatomic, strong) NSString *account_name;
@property(nonatomic, strong) NSString *last_unstaking_time;
@property(nonatomic, strong) NSString *unstaking_balance;
@property(nonatomic, strong) NSString *eos_balance;
@property(nonatomic, strong) NSArray *permissions;
@end
