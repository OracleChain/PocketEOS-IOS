//
//  RedPacketRecordResult.m
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketRecordResult.h"

@implementation RedPacketRecordResult
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : @"RedPacketRecord"
             };
}
@end
