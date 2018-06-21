//
//  EOSResource.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSResource : NSObject


/**
 cpu当前占用
 */
@property(nonatomic , copy) NSString *cpu_used;


/**
 cpu当前可用
 */
@property(nonatomic , copy) NSString *cpu_available;

/**
 cpu总配额
 */
@property(nonatomic , copy) NSString *cpu_max;

/**
 cpu配额抵押
 */
@property(nonatomic , copy) NSString *cpu_weight;



/**
 net当前占用
 */
@property(nonatomic , copy) NSString *net_used;


/**
 net当前可用
 */
@property(nonatomic , copy) NSString *net_available;

/**
 net总配额
 */
@property(nonatomic , copy) NSString *net_max;

/**
 net配额抵押
 */
@property(nonatomic , copy) NSString *net_weight;


@end
