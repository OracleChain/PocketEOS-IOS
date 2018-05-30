//
//  GetRedPacketDetailRequest.h
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"


/**
 get redpacket detail
 */
@interface GetRedPacketDetailRequest : BaseNetworkRequest
/**
 用户id
 */
@property(nonatomic, copy) NSString *redPacket_id;

@end
