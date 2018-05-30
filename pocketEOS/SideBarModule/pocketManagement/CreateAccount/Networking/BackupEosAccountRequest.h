//
//  BackupEosAccountRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"


/**
 给用户添加新的eos账号
 */
@interface BackupEosAccountRequest : BaseNetworkRequest

/**
 用户uid
 */
@property(nonatomic, strong) NSString *uid;

/**
 eos账号名
 */
@property(nonatomic, strong) NSString *eosAccountName;

@end
