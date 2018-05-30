//
//  Rate.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 汇率
 */
@interface Rate : NSObject


/**
 id
 */
@property(nonatomic, copy) NSString *coinmarket_id;

/**
 价格（美元）
 */
@property(nonatomic, copy) NSString *price_usd;

/**
 价格（人民币）
 */
@property(nonatomic, copy) NSString *price_cny;

/**
 24小时内涨跌幅%
 */
@property(nonatomic, copy) NSString *percent_change_24h;


/**
 
 市值（美元）
 */
@property(nonatomic, copy) NSString *market_cap_usd;

/**
 市值（人民币）
 */
@property(nonatomic, copy) NSString *market_cap_cny;

@end
