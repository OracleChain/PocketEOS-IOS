//
//  EOSResourceCellModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSResourceCellModel : NSObject

/**
 
 */
@property(nonatomic , copy) NSString *title;


/**
 当前占用
 */
@property(nonatomic , copy) NSString *used;

/**
 当前可用
 */
@property(nonatomic , copy) NSString *available;

/**
 总配额
 */
@property(nonatomic , copy) NSString *max;

/**
 配额抵押
 */
@property(nonatomic , copy) NSString *weight;

@end
