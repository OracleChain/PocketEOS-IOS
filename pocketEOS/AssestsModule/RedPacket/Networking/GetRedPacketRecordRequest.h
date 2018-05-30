//
//  GetRedPacketRecordRequest.h
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"


@interface GetRedPacketRecordRequest : BaseNetworkRequest
// 获取红包记录
/**
 用户id
 */
@property(nonatomic, copy) NSString *uid;

/**
 账号
 */
@property(nonatomic, copy) NSString *account;

/**
 类型 EOS OCT
 */
@property(nonatomic, copy) NSString *type;

@end
