//
//  GetRedPacketRecordRequest.m
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetRedPacketRecordRequest.h"

@implementation GetRedPacketRecordRequest

- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"http://39.106.118.225:5000/api_oc_business/select_user_red_packet"];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.uid) forKey:@"uid"];
    [params setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [params setObject:VALIDATE_STRING(self.type) forKey:@"type"];
    return [params clearEmptyObject];
}

@end
