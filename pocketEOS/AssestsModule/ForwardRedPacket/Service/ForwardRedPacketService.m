//
//  ForwardRedPacketService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ForwardRedPacketService.h"
#import "AuthRedPacketResult.h"
#import "AuthRedPacket.h"

@implementation ForwardRedPacketService

- (Auth_redpacket_request *)auth_redpacket_request{
    if (!_auth_redpacket_request) {
        _auth_redpacket_request = [[Auth_redpacket_request alloc] init];
    }
    return _auth_redpacket_request;
}


- (void)authRedpacket:(CompleteBlock)complete{
    [self.auth_redpacket_request postDataSuccess:^(id DAO, id data) {
        AuthRedPacketResult *result = [AuthRedPacketResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            complete(result, YES);
        }else{
            [TOASTVIEW showWithText:result.message];
            complete(nil,NO);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil,NO);
    }];
}


@end
