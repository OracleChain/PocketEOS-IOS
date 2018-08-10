//
//  PayRegistAccountService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PayRegistAccountService.h"
#import "WechatPayRespResult.h"
#import "AlipayRespResult.h"
#import "CreateAccountResourceResult.h"
#import "CreateAccountResourceRespModel.h"


@implementation PayRegistAccountService

- (GetCreateAccountResourceRequest *)getCreateAccountResourceRequest{
    if (!_getCreateAccountResourceRequest) {
        _getCreateAccountResourceRequest = [[GetCreateAccountResourceRequest alloc] init];
    }
    return _getCreateAccountResourceRequest;
}
- (CreateAccountOrderRequest *)createAccountOrderRequest{
    if (!_createAccountOrderRequest) {
        _createAccountOrderRequest = [[CreateAccountOrderRequest alloc] init];
    }
    return _createAccountOrderRequest;
}

- (void)getCreateAccountResource:(CompleteBlock)complete{
    [self.getCreateAccountResourceRequest getDataSusscess:^(id DAO, id data) {
        CreateAccountResourceResult *result = [CreateAccountResourceResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            complete(result, YES);
        }else{
            [TOASTVIEW showWithText:result.msg];
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)createAccountOrderByWechatPay:(CompleteBlock)complete{
    [self.createAccountOrderRequest postOuterDataSuccess:^(id DAO, id data) {
        WechatPayRespResult *result = [WechatPayRespResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            complete(result, YES);
        }else{
            [TOASTVIEW showWithText:result.msg];
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)createAccountOrderByAliPay:(CompleteBlock)complete{
    [self.createAccountOrderRequest postOuterDataSuccess:^(id DAO, id data) {
        AlipayRespResult *result = [AlipayRespResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            complete(result, YES);
        }else{
            [TOASTVIEW showWithText:result.msg];
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}


@end
