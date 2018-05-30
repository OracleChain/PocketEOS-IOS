//
//  GetAccountRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/6.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

/**
 区块公共 / 账号详情
 */
@interface GetAccountRequest : BaseHttpsNetworkRequest
/**
 账号名
 */
@property(nonatomic, strong) NSString *name;
@end
