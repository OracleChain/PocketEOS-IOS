//
//  AuthRedPacket.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AuthRedPacket.h"

@implementation AuthRedPacket

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"redpacket_id" : @"id"
             
             };
}

@end
