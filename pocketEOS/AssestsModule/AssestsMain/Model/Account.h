//
//  Account.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 eos账号, 
 */
@interface Account : NSObject

/**
 eos账号名
 */
@property(nonatomic, copy) NSString *account_name;

/**
 eos账号头像
 */
@property(nonatomic, copy) NSString *account_icon;
/**
 eos数量
 */
@property(nonatomic, copy) NSString *eos_balance;

/**
 eos数量对应美元价值
 */
@property(nonatomic, copy) NSString *eos_balance_usd;

/**
 eos数量对应人民币价值
 */
@property(nonatomic, copy) NSString *eos_balance_cny;

/**
 eos价格波动
 */
@property(nonatomic, copy) NSString *eos_price_change_in_24h;

/**
 eos市场总值对应美元
 */
@property(nonatomic, copy) NSString *eos_market_cap_usd;


/**
 市场总值对应人民币
 */
@property(nonatomic, copy) NSString *eos_market_cap_cny;

/**
 美元汇率
 */
@property(nonatomic, copy) NSString *eos_price_usd;

/**
 人民币汇率
 */
@property(nonatomic, copy) NSString *eos_price_cny;




//===================================//
/**
 oct数量
 */
@property(nonatomic, copy) NSString *oct_balance;

/**
 oct数量对应美元价值
 */
@property(nonatomic, copy) NSString *oct_balance_usd;

/**
 
 oct数量对应人民币价值
 */
@property(nonatomic, copy) NSString *oct_balance_cny;

/**
oct价格波动
 */
@property(nonatomic, copy) NSString *oct_price_change_in_24h;

/**
 市场总值对应美元
 */
@property(nonatomic, copy) NSString *oct_market_cap_usd;


/**
 市场总值对应人民币
 */
@property(nonatomic, copy) NSString *oct_market_cap_cny;

/**
 美元汇率
 */
@property(nonatomic, copy) NSString *oct_price_usd;

/**
 人民币汇率
 */
@property(nonatomic, copy) NSString *oct_price_cny;


@end
