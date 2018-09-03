//
//  RedPacketResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"
#import "RedPacket.h"

@interface RedPacketResult : BaseResult

@property(nonatomic , strong) RedPacket *data;

@end
