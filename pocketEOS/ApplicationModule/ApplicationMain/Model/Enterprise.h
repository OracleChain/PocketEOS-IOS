//
//  Enterprise.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enterprise : NSObject

/**
 dapp的id
 */
@property(nonatomic, strong) NSNumber *enterprise_id;

/**
 企业简介
 */
@property(nonatomic, copy) NSString *summary;

/**
 企业名字
 */
@property(nonatomic, copy) NSString *enterpriseName;

/**
 企业宣传图
 */
@property(nonatomic, copy) NSString *publicImage;

/**
 企业图标
 */
@property(nonatomic, copy) NSString *enterpriseIcon;

/**
 权重 1-7表示七个位置展示
 */
@property(nonatomic, strong) NSNumber *weight;

/**
 推荐理由
 */
@property(nonatomic, copy) NSString *introReason;
@end
