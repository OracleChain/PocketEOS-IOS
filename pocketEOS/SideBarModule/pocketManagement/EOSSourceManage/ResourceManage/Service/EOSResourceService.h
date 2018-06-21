//
//  EOSResourceService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetAccountRequest.h"

@interface EOSResourceService : BaseService
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;


/**
 账号资产详情
 */
- (void)get_account:(CompleteBlock)complete;

@end
