//
//  GetTransactionRecordsRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetTransactionRecordsRequest : BaseHttpsNetworkRequest

/**
 必选
 */
@property(nonatomic, strong) NSString *account_name;
/**
 可选，本次查询返回的交易偏移位置
 */
@property(nonatomic, strong) NSNumber *skip_seq;
/**
 可选，本次查询返回的交易个数
 */
@property(nonatomic, strong) NSNumber *num_seq;
@end
