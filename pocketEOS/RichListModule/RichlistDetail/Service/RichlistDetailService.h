//
//  RichlistDetailService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetAccountAssetRequest.h"
#import "GetWalletAccountsRequest.h"


@interface RichlistDetailService : BaseService

@property(nonatomic, strong) GetAccountAssetRequest *getAccountAssetRequest;
@property(nonatomic, strong) GetWalletAccountsRequest  *getWalletAccountsRequest;



// 账号数组
@property(nonatomic, strong) NSMutableArray *accountsArray;


/**
 账号资产详情
 */
- (void)get_account_asset:(CompleteBlock)complete;



/**
 获取他人钱包所有账号
 */
- (void)getWalletAccountsRequest:(CompleteBlock)complete;

@end

