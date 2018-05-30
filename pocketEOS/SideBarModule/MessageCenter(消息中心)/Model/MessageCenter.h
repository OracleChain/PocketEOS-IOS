//
//  MessageCenter.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCenter : NSObject

/**
 标题
 */
@property(nonatomic, strong) NSString *title;

/**
 简介
 */
@property(nonatomic, strong) NSString *summary;
/**
 
 创建时间
 */
@property(nonatomic, strong) NSString *createTime;
/**
 
 更新时间
 */
@property(nonatomic, strong) NSString *updateTime;


@end
