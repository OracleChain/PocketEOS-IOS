//
//  DappDetailService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "ScatterResult_type_requestSignature.h"

@protocol DappDetailServiceDelegate<NSObject>
- (void)scatterBuildExcuteActionsDataSourceDidSuccess:(NSArray *)scatterActions;
@end


@interface DappDetailService : BaseService

@property(nonatomic, weak) id<DappDetailServiceDelegate> delegate;


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

// scatter
@property(nonatomic , strong) ScatterResult_type_requestSignature *requestSignature_scatterResult;
@property(nonatomic , copy) NSString *scatter_request_signatureStr;
@property(nonatomic , copy) NSString *password;
- (void)requestScatterSignature:(CompleteBlock)complete;

// get_table_rows_request params
@property(nonatomic , copy) NSString *code; //octtothemoon
@property(nonatomic , copy) NSString *scope; // oraclechain4
@property(nonatomic , copy) NSString *table; //accounts
@end
