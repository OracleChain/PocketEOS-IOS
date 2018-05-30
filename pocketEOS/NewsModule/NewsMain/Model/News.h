//
//  News.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(nonatomic, strong) NSNumber *news_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSString *summary;
@property(nonatomic, strong) NSNumber *scope;
@property(nonatomic, strong) NSNumber *assetCategoryId;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *newsUrl;
@property(nonatomic, copy) NSString *publisher;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *releaseTime;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *updateTime;

@end
