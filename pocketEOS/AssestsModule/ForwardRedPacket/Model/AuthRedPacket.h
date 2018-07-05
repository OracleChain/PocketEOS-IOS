//
//  AuthRedPacket.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthRedPacket : NSObject

@property(nonatomic , copy) NSString *verifyString;
@property(nonatomic , copy) NSString *endTime;

@end
