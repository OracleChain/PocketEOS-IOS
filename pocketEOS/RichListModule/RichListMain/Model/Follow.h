//
//  Follow.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 关注的账号或者钱包
 */
@interface Follow : NSObject

@property(nonatomic, copy) NSString *uid;

@property(nonatomic, copy) NSString *displayName;

@property(nonatomic, copy) NSString *avatar;

/**
 1 钱包, 2 账号
 */
@property(nonatomic, copy) NSNumber *followType;

@end
