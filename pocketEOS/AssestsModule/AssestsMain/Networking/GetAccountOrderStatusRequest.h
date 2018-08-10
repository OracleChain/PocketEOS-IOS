//
//  GetAccountOrderStatusRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetAccountOrderStatusRequest : BaseNetworkRequest
@property(nonatomic , copy) NSString *accountName;
@property(nonatomic , copy) NSString *uid;
@end
