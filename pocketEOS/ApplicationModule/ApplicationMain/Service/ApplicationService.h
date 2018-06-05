//
//  ApplicationService.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "ApplicationModuleHeaderRequest.h"
#import "ApplicationModuleBodyRequest.h"

@interface ApplicationService : BaseService
@property(nonatomic, strong) ApplicationModuleHeaderRequest *applicationModuleHeaderRequest;
@property(nonatomic, strong) ApplicationModuleBodyRequest *applicationModuleBodyRequest;

/**
 轮播图的图片数组
 */
@property(nonatomic, strong) NSMutableArray *imageURLStringsGroup;
/**
  轮播图数据源
 */
@property(nonatomic, strong) NSMutableArray *bannerDataArray;

/**
  头部展示的四个位置数据源
 */
@property(nonatomic, strong) NSMutableArray *top4DataArray;

/**
   明星应用数据源
 */
@property(nonatomic, strong) NSMutableArray *starDataArray;

/**
   列表应用数据源
 */
@property(nonatomic, strong) NSMutableArray *listDataArray;

- (void)applicationModuleHeaderRequest:(CompleteBlock)complete;
- (void)applicationModuleBodyRequest:(CompleteBlock)complete;

@end
