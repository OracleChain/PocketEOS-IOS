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
    return [NSString stringWithFormat:@"%@/send_red_packet_2", REQUEST_REDPACKET_BASEURL];
//    return @"http://47.105.99.78/api_oc_redpacket/send_red_packet_2";
}

-(id)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.uid) forKey:@"uid"];
    [params setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [params setObject:VALIDATE_NUMBER(self.amount) forKey:@"amount"];
    [params setObject:VALIDATE_NUMBER(self.packetCount) forKey:@"packetCount"];
    [params setObject:VALIDATE_NUMBER(self.type) forKey:@"type" ];
    [params setObject:VALIDATE_STRING(self.remark) forKey:@"remark"];
    return params;
}


@end
