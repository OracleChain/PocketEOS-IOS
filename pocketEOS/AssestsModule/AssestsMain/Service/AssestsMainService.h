//
//  AssestsMainService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetAccountAssetRequest.h"
#import "RichListRequest.h"
#import "GetRateRequest.h"

@interface AssestsMainService : BaseService

@property(nonatomic, strong) GetAccountAssetRequest *getAccountAssetRequest;
@property(nonatomic, strong) RichListRequest *richListRequest;
@property(nonatomic, strong) GetRateRequest *getRateRequest;


/**
 账号资产详情
 */
- (void)get_account_asset:(CompleteBlock)complete;

/**
 get_rate
 */
- (void)get_rate:(CompleteBlock)complete;


@end
