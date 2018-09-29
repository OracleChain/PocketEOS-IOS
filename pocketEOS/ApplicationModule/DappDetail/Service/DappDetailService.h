//
//  DappDetailService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"

@interface DappDetailService : BaseService
@property(nonatomic , copy) NSString *choosedAccountName;
@property(nonatomic , copy) NSString *transactionIdStr;



- (void)getAppInfo:(CompleteBlock)complete;
- (void)walletLanguage:(CompleteBlock)complete;
- (void)getEosAccount:(CompleteBlock)complete;
- (void)getEosBalance:(CompleteBlock)complete;
- (void)getWalletWithAccount:(CompleteBlock)complete;
- (void)getEosAccountInfo:(CompleteBlock)complete;
- (void)getTransactionById:(CompleteBlock)complete;
- (void)unknownMethod:(CompleteBlock)complete;


// get_table_rows_request params
@property(nonatomic , copy) NSString *code; //octtothemoon
@property(nonatomic , copy) NSString *scope; // oraclechain4
@property(nonatomic , copy) NSString *table; //accounts
@end
