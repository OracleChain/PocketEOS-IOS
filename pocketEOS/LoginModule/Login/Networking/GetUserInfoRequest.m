//
//  GetUserInfoRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/5.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetUserInfoRequest.h"

@implementation GetUserInfoRequest
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/get_user", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{@"token" : VALIDATE_STRING(self.token),
             @"type" : VALIDATE_NUMBER(self.type),
             @"from" : VALIDATE_NUMBER(self.from),
             };
}
@end
