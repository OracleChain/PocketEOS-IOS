//
//  Auth_redpacket_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Auth_redpacket_request.h"

@implementation Auth_redpacket_request
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/auth_message", REQUEST_REDPACKET_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.redPacket_id) forKey:@"id"];
    [params setObject:VALIDATE_STRING(self.transactionId) forKey:@"transactionId"];
    return [params clearEmptyObject];
}




@end
