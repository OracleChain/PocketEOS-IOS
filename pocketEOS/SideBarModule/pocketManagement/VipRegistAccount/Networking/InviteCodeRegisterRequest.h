//
//  InviteCodeRegisterRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface InviteCodeRegisterRequest : BaseNetworkRequest
/**
 用户uid
 */
@property(nonatomic, copy) NSString *inviteCode;


/**
 用户uid
 */
@property(nonatomic, copy) NSString *uid;

/**
 eos账号名
 */
@property(nonatomic, copy) NSString *eosAccountName;

/**
 activeKey
 */
@property(nonatomic, copy) NSString *activeKey;

/**
 onwerKey
 */
@property(nonatomic, copy) NSString *ownerKey;



@end
