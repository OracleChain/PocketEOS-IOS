//
//  LoginService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetVerifyCodeRequest.h"
#import "AuthVerifyCodeRequest.h"

@interface LoginService : BaseService

@property(nonatomic, strong) GetVerifyCodeRequest *getVerifyCodeRequest;

@property(nonatomic, strong) AuthVerifyCodeRequest *authVerifyCodeRequest;

/**
 获取验证码
 */
- (void)getVerifyCode:(CompleteBlock)complete;


/**
 认证短信码
 */
- (void)authVerifyCode:(CompleteBlock)complete;

@end
