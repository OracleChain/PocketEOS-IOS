//
//  PayRegistAccountService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetCreateAccountResourceRequest.h"
#import "CreateAccountOrderRequest.h"


@interface PayRegistAccountService : BaseService

@property(nonatomic , strong) GetCreateAccountResourceRequest *getCreateAccountResourceRequest;
@property(nonatomic , strong) CreateAccountOrderRequest *createAccountOrderRequest;

- (void)getCreateAccountResource:(CompleteBlock)complete;



- (void)createAccountOrderByWechatPay:(CompleteBlock)complete;

- (void)createAccountOrderByAliPay:(CompleteBlock)complete;
@end
