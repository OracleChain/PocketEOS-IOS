//
//  EOSResource.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResource.h"

@implementation EOSResource

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"cpu_used" : @"cpu_limit.used",
             @"cpu_available" : @"cpu_limit.available",
             @"cpu_max" : @"cpu_limit.max",
             @"cpu_weight" : @"total_resources.cpu_weight",
             @"net_used" : @"net_limit.used",
             @"net_available" : @"net_limit.available",
             @"net_max" : @"net_limit.max",
             @"net_weight" : @"total_resources.net_weight",
             @"ram_max" : @"total_resources.ram_bytes",
             @"self_delegated_bandwidth_net" : @"self_delegated_bandwidth.net_weight",
             @"self_delegated_bandwidth_cpu" : @"self_delegated_bandwidth.cpu_weight",
             @"refund_request_cpu_amount" : @"refund_request.cpu_amount",
             @"refund_request_net_amount" : @"refund_request.net_amount",
             @"refund_request_time" : @"refund_request.request_time"
             
             };
}


@end
