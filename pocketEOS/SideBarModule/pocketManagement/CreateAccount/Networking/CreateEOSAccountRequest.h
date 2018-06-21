//
//  CreateEOSAccountRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface CreateEOSAccountRequest : BaseNetworkRequest
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
