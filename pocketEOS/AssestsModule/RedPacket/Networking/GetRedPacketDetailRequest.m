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
    return [NSString stringWithFormat:@"http://39.106.118.225:5000/app/mock/24/POST/39.106.118.225:8080/api_oc_business/selectRedPacketRecord/"];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.redPacket_id) forKey:@"id"];
    return [params clearEmptyObject];
}
@end
