//
//  GetVerifyCodeRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetVerifyCodeRequest.h"

@implementation GetVerifyCodeRequest
- (NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/message/send", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    
    return @{@"phoneNum" : self.phoneNum};
}
@end
