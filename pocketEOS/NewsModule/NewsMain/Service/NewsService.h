//
//  NewsService.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "NewsRequest.h"
#import "GetAssetCategoryAllRequest.h"

@interface NewsService : BaseService

@property(nonatomic, strong) NewsRequest *newsRequest;
@property(nonatomic, strong) GetAssetCategoryAllRequest *getAssetCategoryAllRequest;

@property(nonatomic, strong) NSMutableArray *allAssetsArray;

- (void)buildNextPageDataSource:(CompleteBlock)complete;

- (void)GetAssetCategoryAllRequest:(CompleteBlock)complete;

@end
