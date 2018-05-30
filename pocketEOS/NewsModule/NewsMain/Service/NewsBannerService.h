//
//  NewsBannerService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/12.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "NewsRequest.h"

/**
 轮播图服务
 */
@interface NewsBannerService : BaseService

@property(nonatomic, strong) NewsRequest *newsRequest;

/**
 轮播图的图片数组
 */
@property(nonatomic, strong) NSMutableArray *imageURLStringsGroup;

@end
