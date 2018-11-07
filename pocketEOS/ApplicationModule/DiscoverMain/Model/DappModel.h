//
//  DappModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DappModel : NSObject


/**
 id
 */
@property(nonatomic , copy) NSString *dapp_id;

/**
 应用名称
 */
@property(nonatomic , copy) NSString *dappName;

/**
 应用简介
 */
@property(nonatomic , copy) NSString *dappIntro;

/**
 应用图标 （小） 普通展示
 */
@property(nonatomic , copy) NSString *dappIcon;

/**
 应用图片 （中） 明星位展示
 */
@property(nonatomic , copy) NSString *dappImage;

/**
 应用图片 （大） banner位展示
 */
@property(nonatomic , copy) NSString *dappPicture;

/**
 应用地址
 */
@property(nonatomic , copy) NSString *dappUrl;

/**
 status
 */
@property(nonatomic , copy) NSString *status;



/**
 推荐理由
 */
@property(nonatomic , copy) NSString *introReason;

/**
 类别描述
 */
@property(nonatomic , copy) NSString *dappCategoryName;

/**
 字体颜色
 */
@property(nonatomic , copy) NSString *textColor;

/**
 标记颜色
 */
@property(nonatomic , copy) NSString *tagColor;


@end

NS_ASSUME_NONNULL_END
