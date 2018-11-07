//
//  Get_dapp_by_config_id_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface Get_dapp_by_config_id_request : BaseNetworkRequest
@property(nonatomic , copy) NSString *config_id;
@end

NS_ASSUME_NONNULL_END
