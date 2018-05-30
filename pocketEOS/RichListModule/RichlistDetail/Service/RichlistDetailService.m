//
//  RichlistDetailService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "RichlistDetailService.h"
#import "GetAccountAssetRequest.h"
#import "AccountResult.h"
#import "WalletAccountsResult.h"
#import "WalletAccount.h"
#import "Assests.h"
#import "AccountResult.h"
#import "Account.h"

@implementation RichlistDetailService
- (GetAccountAssetRequest *)getAccountAssetRequest{
    if (!_getAccountAssetRequest) {
        _getAccountAssetRequest = [[GetAccountAssetRequest alloc] init];
    }
    return _getAccountAssetRequest;
}

- (GetWalletAccountsRequest *)getWalletAccountsRequest{
    if (!_getWalletAccountsRequest) {
        _getWalletAccountsRequest = [[GetWalletAccountsRequest alloc] init];
    }
    return _getWalletAccountsRequest;
}

- (NSMutableArray *)accountsArray{
    if (!_accountsArray) {
        _accountsArray = [[NSMutableArray alloc] init];
    }
    return _accountsArray;
}
/**
 账号资产详情
 */
- (void)get_account_asset:(CompleteBlock)complete{
    WS(weakSelf);
    [self.getAccountAssetRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AccountResult *result = [AccountResult mj_objectWithKeyValues:data];
            Assests *eos = [[Assests alloc] init];
            eos.assestsName = @"eos";
            eos.assests_avtar = @"eos_avatar";
            eos.assests_balance = VALIDATE_STRING(result.data.eos_balance);
            eos.assests_balance_cny = VALIDATE_STRING(result.data.eos_balance_cny);
            eos.assests_balance_usd = VALIDATE_STRING(result.data.eos_balance_usd);
            eos.assests_price_change_in_24 = VALIDATE_STRING(result.data.eos_price_change_in_24h);
            eos.assests_market_cap_usd = VALIDATE_STRING(result.data.eos_market_cap_usd);
            eos.assests_market_cap_cny = VALIDATE_STRING(result.data.eos_market_cap_cny);
            eos.assests_price_cny = VALIDATE_STRING(result.data.eos_price_cny);
            eos.assests_price_usd = VALIDATE_STRING(result.data.eos_price_usd);
            
            Assests *oct = [[Assests alloc] init];
            oct.assestsName = @"oct";
            oct.assests_avtar = @"oct_avatar";
            oct.assests_balance = VALIDATE_STRING(result.data.oct_balance);
            oct.assests_balance_cny = VALIDATE_STRING(result.data.oct_balance_cny);
            oct.assests_balance_usd = VALIDATE_STRING(result.data.oct_balance_usd);
            oct.assests_price_change_in_24 = VALIDATE_STRING(result.data.oct_price_change_in_24h);
            oct.assests_market_cap_usd = VALIDATE_STRING(result.data.oct_market_cap_usd);
            oct.assests_market_cap_cny = VALIDATE_STRING(result.data.oct_market_cap_cny);
            oct.assests_price_cny = VALIDATE_STRING(result.data.oct_price_cny);
            oct.assests_price_usd = VALIDATE_STRING(result.data.oct_price_usd);
            
            weakSelf.dataSourceArray = [NSMutableArray arrayWithObjects:eos, oct, nil];
            
            complete(result, YES);
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
        
    }];
}

/**
 获取他人钱包所有账号
 */
- (void)getWalletAccountsRequest:(CompleteBlock)complete{
    WS(weakSelf);
    [self.getWalletAccountsRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            WalletAccountsResult *result = [WalletAccountsResult mj_objectWithKeyValues:data];
            weakSelf.accountsArray = VALIDATE_ARRAY(result.data);
            complete(result, YES);
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}


@end
