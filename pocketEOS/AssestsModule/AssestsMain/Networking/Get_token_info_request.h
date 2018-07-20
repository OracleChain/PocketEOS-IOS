//
//  Get_token_info_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface Get_token_info_request : BaseNetworkRequest

@property(nonatomic, strong) NSString *accountName;

@property(nonatomic , strong) NSMutableArray *ids;

@end
