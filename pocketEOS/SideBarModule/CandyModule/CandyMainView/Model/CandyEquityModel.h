//
//  CandyEquityModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CandyEquityModel : NSObject
@property(nonatomic , copy) NSString *equity_id;
@property(nonatomic , copy) NSString *title;
@property(nonatomic , copy) NSString *equity_description;
@property(nonatomic , copy) NSString *avatar;
@property(nonatomic , copy) NSString *weight;
@property(nonatomic , copy) NSString *exchangeTimes;
@property(nonatomic , copy) NSString *scoreValue;
@property(nonatomic , copy) NSString *tokenValue;
@property(nonatomic , copy) NSString *tokenType;
@property(nonatomic , copy) NSString *status;
@property(nonatomic , copy) NSString *exchangeUrl;
@property(nonatomic , copy) NSString *createTime;
@property(nonatomic , copy) NSString *updateTime;
@end
