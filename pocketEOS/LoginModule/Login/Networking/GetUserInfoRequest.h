//
//  GetUserInfoRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/5.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetUserInfoRequest : BaseNetworkRequest
/**
 用于查询用户信息的token
 */
@property(nonatomic, copy) NSString *token;
/**
 0：uid查询，1：wechat查询 2：qq查询
 */
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic , copy) NSString *from;
@end
