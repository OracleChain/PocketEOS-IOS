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
 account_name
 */
@property(nonatomic , copy) NSString *account_name;


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


/**
 ram总配额
 */
@property(nonatomic , copy) NSString *ram_max;

/**
 ram使用情况
 */
@property(nonatomic , copy) NSString *ram_usage;



/**
 self_delegated_bandwidth
 */
@property(nonatomic , strong) NSDictionary *self_delegated_bandwidth;

/**
 self_delegated_bandwidth_net
 */
@property(nonatomic , copy) NSString *self_delegated_bandwidth_net;

/**
 self_delegated_bandwidth_cpu
 */
@property(nonatomic , copy) NSString *self_delegated_bandwidth_cpu;



@property(nonatomic , strong) NSDictionary *refund_request;


/**
 refund_request_cpu_amount
 */
@property(nonatomic , copy) NSString *refund_request_cpu_amount;

/**
 refund_request_net_amount
 */
@property(nonatomic , copy) NSString *refund_request_net_amount;

/**
 refund_request_time
 */
@property(nonatomic , copy) NSString *refund_request_time;



@property(nonatomic , copy) NSString *core_liquid_balance;


@end
