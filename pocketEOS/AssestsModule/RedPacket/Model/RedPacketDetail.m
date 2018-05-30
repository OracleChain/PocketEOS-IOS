//
//  RedPacketDetail.m
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketDetail.h"

@implementation RedPacketDetail

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"residueCount" : @"statistics.residueCount",
             @"residueAmount" : @"statistics.residueAmount",
             @"packetCount" : @"statistics.packetCount",
             @"amount" : @"statistics.amount",
             @"isSend" : @"statistics.isSend"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"redPacketOrderRedisDtos" : @"RedPacketDetailSingleAccount"
             };
}

@end
