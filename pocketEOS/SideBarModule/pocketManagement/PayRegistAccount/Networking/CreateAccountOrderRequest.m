//
//  CreateAccountOrderRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CreateAccountOrderRequest.h"

@implementation CreateAccountOrderRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/createAccountOrder", REQUEST_PAY_CREATEACCOUNT_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.payChannel) forKey:@"payChannel"];
    [params setObject:VALIDATE_STRING(self.accountName) forKey:@"accountName"];
    [params setObject:VALIDATE_STRING(self.openid) forKey:@"openid"];
    [params setObject:VALIDATE_STRING(self.timeOut) forKey:@"timeOut"];
    [params setObject:VALIDATE_STRING(self.feeAmount) forKey:@"feeAmount"];
    [params setObject:VALIDATE_STRING(self.userId) forKey:@"userId"];
    [params setObject:VALIDATE_STRING(self.ownerKey) forKey:@"ownerKey"];
    [params setObject:VALIDATE_STRING(self.activeKey) forKey:@"activeKey"];
    
    return [params clearEmptyObject];
}



@end
