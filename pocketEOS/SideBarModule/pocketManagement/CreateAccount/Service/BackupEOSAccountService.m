
//
//  BackupEOSAccountService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BackupEOSAccountService.h"
#import "BackupEosAccountRequest.h"

@implementation BackupEOSAccountService

- (BackupEosAccountRequest *)backupEosAccountRequest{
    if (!_backupEosAccountRequest) {
        _backupEosAccountRequest = [[BackupEosAccountRequest alloc] init];
    }
    return _backupEosAccountRequest;
}
- (void)backupAccount:(CompleteBlock)complete{
    
    [self.backupEosAccountRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            complete(data , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
    
}

@end
