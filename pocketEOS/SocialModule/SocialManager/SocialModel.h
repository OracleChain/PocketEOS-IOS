//
//  SocialModel.h
//  pocketEOS
//
//  Created by oraclechain on 30/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialModel : NSObject

/**
 昵称
 */
@property(nonatomic , copy) NSString *name;

/**
 头像地址
 */
@property(nonatomic , copy) NSString *avatar;

/**
 openid
 */
@property(nonatomic , copy) NSString *openid;


/**
 1 代表 qq 2 代表微信 不能有其他值
 */
@property(nonatomic , copy) NSString *type;


@end
