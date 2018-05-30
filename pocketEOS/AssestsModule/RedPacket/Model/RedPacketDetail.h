//
//  RedPacketDetail.h
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 红包应用 / 查询红包被领取记录
 */
@interface RedPacketDetail : NSObject


/**
 当isSend为true时，表示剩余红包数，当isSend为false时，，没有该字段
 */
@property(nonatomic , strong) NSNumber *residueCount;


/**
 当issend为true是，表示红包剩余金额，为false时没有该字段
 */
@property(nonatomic , copy) NSString *residueAmount;



/**
 当isSend为true时，表示 发送的红包个数，当isSend为false时，，没有该字段
 */
@property(nonatomic , strong) NSNumber *packetCount;


/**
 当isSend为true时，表示 发送的总金额，当isSend为false时，表示领取的红包金额
 */
@property(nonatomic , copy) NSString *amount;



/**
 为true是发送信息，false表示领取信息
 */
@property(nonatomic , copy) NSString *isSend;

/**
 redPacketOrderRedisDtos
 */
@property(nonatomic , strong) NSMutableArray *redPacketOrderRedisDtos;



@end
