//
//  GetRateRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetRateRequest : BaseHttpsNetworkRequest
/**
 coinmarket_id
 */
@property(nonatomic, strong) NSString *coinmarket_id;
@end
