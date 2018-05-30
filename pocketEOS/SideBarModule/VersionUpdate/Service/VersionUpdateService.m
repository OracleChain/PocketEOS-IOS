//
//  VersionUpdateService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "VersionUpdateService.h"

@implementation VersionUpdateService

- (GetVersionInfoRequest *)getVersionInfoRequest{
    if (!_getVersionInfoRequest) {
        _getVersionInfoRequest = [[GetVersionInfoRequest alloc] init];
    }
    return _getVersionInfoRequest;
}

- (void)getVersionInfo:(CompleteBlock)complete{
    
    [self.getVersionInfoRequest getDataSusscess:^(id DAO, id data) {
        
    } failure:^(id DAO, NSError *error) {
        
    }];
}

@end
