//
//  AccountPravicyProtectionRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworkRequest.h"

@interface AccountPravicyProtectionRequest : BaseNetworkRequest
/**
 需要更改隐私状态的账号名
 */
@property(nonatomic, copy) NSString *eosAccountName;

/**
 设置账号的状态 1：隐藏 0：显示
 */
@property(nonatomic, strong) NSNumber *status;

@end
