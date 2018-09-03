//
//  PayOrderRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface PayOrderRequest : BaseNetworkRequest

@property(nonatomic , copy) NSString *userId;

/**
 外部业务号（红包业务）
 */
@property(nonatomic , copy) NSString *outTradeNo;

@property(nonatomic , copy) NSString *trxId;

/**
 同创建订单的memo
 */
@property(nonatomic , copy) NSString *memo;

@property(nonatomic , copy) NSString *blockNum;

/**
 创建支付订单时候返回的
 */
@property(nonatomic , copy) NSString *prepayId;


@end
