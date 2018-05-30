//
//  BaseService.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/30.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseService : NSObject

typedef void(^CompleteBlock)(id service , BOOL isSuccess);


// 接口返回数据
@property(nonatomic, strong) NSMutableArray *responseArray;

// 控件数据源
@property(nonatomic, strong) NSMutableArray *dataSourceArray;


/**
 构建数据源

 @param complete 数据构建成功的回调
 */
- (void)buildDataSource:(CompleteBlock)complete;

@end
