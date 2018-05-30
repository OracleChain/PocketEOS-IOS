//
//  LoginService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "LoginService.h"
#import "AuthResult.h"
#import "Wallet.h"

@implementation LoginService

- (GetVerifyCodeRequest *)getVerifyCodeRequest{
    if (!_getVerifyCodeRequest) {
        _getVerifyCodeRequest = [[GetVerifyCodeRequest alloc] init];
    }
    return _getVerifyCodeRequest;
}

- (AuthVerifyCodeRequest *)authVerifyCodeRequest{
    if (!_authVerifyCodeRequest) {
        _authVerifyCodeRequest = [[AuthVerifyCodeRequest alloc] init];
    }
    return _authVerifyCodeRequest;
}

/**
 获取验证码
 */
- (void)getVerifyCode:(CompleteBlock)complete{
    [self.getVerifyCodeRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]] ) {
            complete(data , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}

/**
 认证短信码
 */
- (void)authVerifyCode:(CompleteBlock)complete{
    
    [self.authVerifyCodeRequest postDataSuccess :^(id DAO, id data) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            AuthResult *result = [AuthResult mj_objectWithKeyValues:data];
            
            complete(result, YES);
        }
        
    } failure:^(id DAO, NSError *error) {
        
        complete(nil , NO);
    }];
    
}


@end
