//
//  Application.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application : NSObject


/**
 dapp的id
 */
@property(nonatomic, strong) NSNumber *application_id;

/**
 应用详情
 */
@property(nonatomic, copy) NSString *applyDetails;

/**
 
 应用名字
 */
@property(nonatomic, copy) NSString *applyName;

/**
 应用图标
 */
@property(nonatomic, copy) NSString *applyIcon;
/**
 权重 已经排序，第一位是明星应用
 */
@property(nonatomic, copy) NSNumber *weight;

/**
 推荐理由
 */
@property(nonatomic, copy) NSString *introReason;


@property(nonatomic , copy) NSString *url;

@end
