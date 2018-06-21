//
//  BackupEOSAccountService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "BackupEosAccountRequest.h"

@interface BackupEOSAccountService : BaseService
@property(nonatomic, strong) BackupEosAccountRequest *backupEosAccountRequest;

/**
 备份账号到服务器
 */
- (void)backupAccount:(CompleteBlock)complete;

@end
