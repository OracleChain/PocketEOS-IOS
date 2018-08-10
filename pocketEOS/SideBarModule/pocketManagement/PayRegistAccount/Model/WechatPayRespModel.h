//
//  WechatPayRespModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatPayRespModel : NSObject


@property(nonatomic , copy) NSString *appId;

@property(nonatomic , copy) NSString *partnerId;

@property(nonatomic , copy) NSString *prepayId;

@property(nonatomic , copy) NSString *exPackage;

@property(nonatomic , copy) NSString *nonceStr;

@property(nonatomic , copy) NSString *timestamp;

@property(nonatomic , copy) NSString *sign;


@end
