//
//  GetAccountAssetRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetAccountAssetRequest : BaseHttpsNetworkRequest

/**
 账号名
 */
@property(nonatomic, strong) NSString *name;
@end
