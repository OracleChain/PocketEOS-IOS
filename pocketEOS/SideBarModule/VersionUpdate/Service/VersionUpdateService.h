//
//  VersionUpdateService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetVersionInfoRequest.h"

@interface VersionUpdateService : BaseService

@property(nonatomic , strong) GetVersionInfoRequest *getVersionInfoRequest;

- (void)getVersionInfo:(CompleteBlock)complete;

@end
