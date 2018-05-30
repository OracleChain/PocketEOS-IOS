//
//  SendRedpacketRequest.m
//  pocketEOS
//
//  Created by oraclechain on 16/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SendRedpacketRequest.h"

@implementation SendRedpacketRequest

- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"http://39.106.118.225:8080/api_oc_business/send_red_packet"];
}

-(id)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.uid) forKey:@"uid"];
    [params setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [params setObject:VALIDATE_NUMBER(self.amount) forKey:@"amount"];
    [params setObject:VALIDATE_NUMBER(self.packetCount) forKey:@"packetCount"];
    [params setObject:VALIDATE_NUMBER(self.type) forKey:@"type" ];

    return [params clearEmptyObject];
}


@end
