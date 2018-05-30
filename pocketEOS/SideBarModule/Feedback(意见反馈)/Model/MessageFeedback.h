//
//  MessageFeedback.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageFeedback : NSObject

/**
 提交反馈的用户uid
 */
@property(nonatomic, strong) NSString *uid;

/**
 提价的内容
 */
@property(nonatomic, strong) NSString *content;

/**
 客服填写的评论
 */
@property(nonatomic, strong) NSString *comment;

/**
 1 表示已经评论 0 表示未评论
 */
@property(nonatomic, strong) NSString *status;

@end
