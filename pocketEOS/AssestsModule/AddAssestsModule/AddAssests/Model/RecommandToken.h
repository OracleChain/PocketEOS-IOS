//
//  RecommandToken.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandToken : NSObject

/**
 RecommandToken id
 */
@property(nonatomic, copy) NSString *recommandToken_ID;

/**
 token 名字
 */
@property(nonatomic, copy) NSString *assetName;

/**
 合约名字
 */
@property(nonatomic, copy) NSString *contractName;

/**
 资产汇率市场查询主键
 */
@property(nonatomic, copy) NSString *coinmarketId;

/**
 小图标
 */
@property(nonatomic, copy) NSString *iconUrl;

/**
 大图标
 */
@property(nonatomic, copy) NSString *iconUrlHd;

/**
 是否关注
 */
@property(nonatomic, assign) BOOL isFollow;




@end
