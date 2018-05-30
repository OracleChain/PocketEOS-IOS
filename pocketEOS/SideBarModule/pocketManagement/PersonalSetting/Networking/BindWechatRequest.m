//
//  BindWechatRequest.m
//  pocketEOS
//
//  Created by oraclechain on 30/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BindWechatRequest.h"

@implementation BindWechatRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/bindwechat", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{@"uid" : VALIDATE_STRING(self.uid),
             @"name" : VALIDATE_STRING(self.name),
             @"avatar" : VALIDATE_STRING(self.avatar),
             @"openid" : VALIDATE_STRING(self.openid),
             };
}
@end
