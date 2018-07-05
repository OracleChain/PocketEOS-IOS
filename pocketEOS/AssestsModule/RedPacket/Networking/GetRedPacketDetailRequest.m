//
//  GetRedPacketDetailRequest.m
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetRedPacketDetailRequest.h"

@implementation GetRedPacketDetailRequest
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/selectRedPacketRecord", REQUEST_REDPACKET_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.redPacket_id) forKey:@"id"];
    return [params clearEmptyObject];
}
@end
