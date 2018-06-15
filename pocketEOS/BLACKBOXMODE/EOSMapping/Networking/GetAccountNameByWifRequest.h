//
//  GetAccountNameByWifRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetAccountNameByWifRequest : BaseNetworkRequest
@property(nonatomic , copy) NSString *public_key;
@end
