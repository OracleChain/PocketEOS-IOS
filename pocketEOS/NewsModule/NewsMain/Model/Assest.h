//
//  Assest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 新闻根据 资产类型进行筛选
 */
@interface Assest : NSObject

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSString *assetName;

@property(nonatomic, assign) BOOL selected;
@end
