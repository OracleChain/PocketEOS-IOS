//
//  CancleFollowRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"
/**
 取消关注
 */
@interface CancleFollowRequest : BaseNetworkRequest
/**
 必填，关注者 uid
 */
@property(nonatomic, strong) NSString *fuid;


/**
 必填，关注对象类型，1：用户钱包，2：账号
 */
@property(nonatomic, strong) NSNumber *followType;

/**
 选填 ，取消关注者，如果取消关注的是账号即followType=2该字段不填，如果关注的是用户的钱包即followType=1则该字段必填
 */
@property(nonatomic, strong) NSString *uid;

/**
 选填 ，账号名字，如果关注的是账号即followType=2该字段必填，如果关注的是用户的钱包即followType=1则该字段不填
 */
@property(nonatomic, strong) NSString *followTarget;

@end
