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
    WS(weakSelf);
    [SVProgressHUD showWithStatus:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.auth_redpacket_request postDataSuccess:^(id DAO, id data) {
            
            AuthRedPacketResult *result = [AuthRedPacketResult mj_objectWithKeyValues:data];
            if ([result.code isEqualToNumber:@0]) {
                complete(result, YES);
            }else{
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
                complete(nil,NO);
            }
        } failure:^(id DAO, NSError *error) {
            complete(nil,NO);
        }];
        
    });
}


@end
