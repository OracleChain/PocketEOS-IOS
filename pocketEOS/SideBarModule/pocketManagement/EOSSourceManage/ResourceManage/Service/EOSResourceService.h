//
//  EOSResourceService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetAccountRequest.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"


@interface EOSResourceService : BaseService
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;

@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
/**
 账号资产详情
 */
- (void)get_account:(CompleteBlock)complete;



@end
