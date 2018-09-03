//
//  Auth_redpacket_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface Auth_redpacket_request : BaseNetworkRequest
@property(nonatomic, copy) NSString *redPacket_id;
@end
