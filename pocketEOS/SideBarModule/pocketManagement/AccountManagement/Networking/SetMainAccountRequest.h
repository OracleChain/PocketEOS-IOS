//
//  SetMainAccountRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface SetMainAccountRequest : BaseNetworkRequest

/**
 用户的uid
 */
@property(nonatomic, strong) NSString *uid;

/**
 需要切换成主账号的用户账号
 */
@property(nonatomic, strong) NSString *eosAccountName;
@end
