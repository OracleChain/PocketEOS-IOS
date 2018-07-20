//
//  Get_user_custom_token_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface Get_user_custom_token_request : BaseNetworkRequest
@property(nonatomic , copy) NSString *accountName;
@end
