//
//  Assests.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 资产模型
 */
@interface Assests : NSObject


/**
 资产名称
 */
@property(nonatomic, copy) NSString *assestsName;

/**
 资产头像
 */
@property(nonatomic, copy) NSString *assests_avtar;


/**
 数量
 */
@property(nonatomic, copy) NSString *assests_balance;

/**
 数量对应人民币价值
 */
@property(nonatomic, copy) NSString *assests_balance_cny;

/**
 数量对应美元价值
 */
@property(nonatomic, copy) NSString *assests_balance_usd;

/**
 价格波动
 */
@property(nonatomic, copy) NSString *assests_price_change_in_24;


/**
 市场总值对应美元
 */
@property(nonatomic, copy) NSString *assests_market_cap_usd;

/**
 市场总值对应人民币
 */
@property(nonatomic, copy) NSString *assests_market_cap_cny;

/**
 人民币汇率
 */
@property(nonatomic, copy) NSString *assests_price_cny;

/**
 美元汇率
 */
@property(nonatomic, copy) NSString *assests_price_usd;
@end
