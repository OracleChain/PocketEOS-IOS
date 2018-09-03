//
//  RedPacketModel.h
//  pocketEOS
//
//  Created by oraclechain on 13/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacketModel : NSObject

@property(nonatomic , copy) NSString *redPacket_id;
@property(nonatomic , copy) NSString *verifystring;
@property(nonatomic , copy) NSString *transactionId;
@property(nonatomic , copy) NSString *from;
@property(nonatomic , copy) NSString *amount;
@property(nonatomic , copy) NSString *count;
@property(nonatomic , copy) NSString *coin;
@property(nonatomic , copy) NSString *memo;
@property(nonatomic , assign) BOOL isSend;
@property(nonatomic , strong) NSNumber *status;
@end
