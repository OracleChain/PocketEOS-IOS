//
//  RedPacketRecord.m
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketRecord.h"

@implementation RedPacketRecord
+(NSDictionary *)mj_replacedKeyFromPropertyName{
     return @{@"redpacket_id" : @"id" };
}
@end
