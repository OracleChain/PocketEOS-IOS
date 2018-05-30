//
//  BindWechatRequest.h
//  pocketEOS
//
//  Created by oraclechain on 30/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface BindWechatRequest : BaseNetworkRequest

/**
 用户uid
 */
@property(nonatomic , copy) NSString *uid;
/**
 昵称
 */
@property(nonatomic , copy) NSString *name;

/**
 头像地址
 */
@property(nonatomic , copy) NSString *avatar;

/**
 openid
 */
@property(nonatomic , copy) NSString *openid;
@end
