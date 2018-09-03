//
//  AuthRedPacket.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthRedPacket : NSObject

@property(nonatomic , copy) NSString *verifyString;

/**
public static Byte waittopay =0;//待支付 public static Byte success=1;//支付成功 public static Byte close=2;////未付款交易超时关闭，或支付完成后全额退款 public static Byte finish=3;////交易结束，不可退款 public static Byte waittocheck=4;////等待交易确认 public static Byte attack=5;////攻击性 public static Byte payfailure=6;////支付失败，需要重新支付
 */
@property(nonatomic , strong) NSNumber *payStatus;

@property(nonatomic , copy) NSString *createTime;

@property(nonatomic , copy) NSString *memo;

@property(nonatomic , strong) NSNumber *blockNum;

@property(nonatomic , copy) NSString *sureBlockNum;

@property(nonatomic , copy) NSString *tokenName;

@property(nonatomic , strong) NSNumber *payAmont;

@property(nonatomic , copy) NSString *transaction_id;

@property(nonatomic , copy) NSString *redpacket_id;

@property(nonatomic , copy) NSString *endTime;

@end
