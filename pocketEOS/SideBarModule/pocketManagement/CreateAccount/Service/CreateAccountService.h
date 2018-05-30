//
//  CreateAccountService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "CreateAccountRequest.h"
#import "BackupEosAccountRequest.h"

@interface CreateAccountService : BaseService
@property(nonatomic, strong) CreateAccountRequest *createAccountRequest;
@property(nonatomic, strong) BackupEosAccountRequest *backupEosAccountRequest;

- (void)createAccount:(CompleteBlock)complete;


/**
 备份账号到服务器
 */
- (void)backupAccount:(CompleteBlock)complete;

@end
