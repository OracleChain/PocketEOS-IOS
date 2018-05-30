//
//  GetWalletAccountsRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"


@interface GetWalletAccountsRequest : BaseNetworkRequest
@property(nonatomic, strong) NSString *uid;
@end
