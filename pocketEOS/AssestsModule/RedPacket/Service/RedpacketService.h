//
//  RedpacketService.h
//  pocketEOS
//
//  Created by oraclechain on 16/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "SendRedpacketRequest.h"
#import "GetRedPacketRecordRequest.h"
#import "GetRedPacketDetailRequest.h"
#import "PayOrderRequest.h"

@interface RedpacketService : BaseService
@property(nonatomic , strong) SendRedpacketRequest *sendRedpacketRequest;
@property(nonatomic , strong) GetRedPacketRecordRequest *getRedPacketRecordRequest;
@property(nonatomic , strong) GetRedPacketDetailRequest *getRedPacketDetailRequest;
@property(nonatomic , strong) PayOrderRequest *payOrderRequest;

- (void)sendRedPacket:(CompleteBlock)complete;
- (void)getRedPacketDetail:(CompleteBlock)complete;
- (void)payOrder:(CompleteBlock)complete;

@end
