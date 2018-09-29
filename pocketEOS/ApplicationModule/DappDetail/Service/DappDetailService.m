//
//  DappDetailService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DappDetailService.h"
#import "GetAccountRequest.h"
#import "GetAccount.h"
#import "GetAccountResult.h"
#import "GetTransactionByIdRequest.h"
#import "Get_table_rows_request.h"
#import "BalanceModel.h"

@interface DappDetailService()
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@property(nonatomic , strong) GetTransactionByIdRequest *getTransactionByIdRequest;
@property (nonatomic , strong) Get_table_rows_request *get_table_rows_request;
@end



@implementation DappDetailService

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (GetTransactionByIdRequest *)getTransactionByIdRequest{
    if (!_getTransactionByIdRequest) {
        _getTransactionByIdRequest = [[GetTransactionByIdRequest alloc] init];
    }
    return _getTransactionByIdRequest;
}

-(Get_table_rows_request *)get_table_rows_request{
    if (!_get_table_rows_request) {
        _get_table_rows_request = [[Get_table_rows_request alloc] init];
    }
    return _get_table_rows_request;
}

- (void)getAppInfo:(CompleteBlock)complete{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue: VALIDATE_STRING(@"PocketEosIOS") forKey:@"app"];
    [dataDict setValue: VALIDATE_STRING([self queryAppVersionInBundle]) forKey:@"app_version"];
    [dataDict setValue: VALIDATE_STRING(@"pe-js-sdk") forKey:@"protocol_name"];
    [dataDict setValue: VALIDATE_STRING(@"1.0.4") forKey:@"protocol_version"];
    [resultDict setValue:dataDict forKey:@"data"];
    [resultDict setValue:@0 forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(@"success") forKey:@"message"];
    complete([resultDict mj_JSONString], YES);
    
}

- (void)walletLanguage:(CompleteBlock)complete{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setValue:@0 forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(@"success") forKey:@"message"];
    if ([NSBundle isChineseLanguage]) {
        [resultDict setValue:@"Chinese" forKey:@"data"];
    }else{
        [resultDict setValue:@"English" forKey:@"data"];
    }
    complete([resultDict mj_JSONString], YES );
}

- (void)getEosAccount:(CompleteBlock)complete{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setValue:@0 forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(@"success") forKey:@"message"];
    [resultDict setValue:VALIDATE_STRING(self.choosedAccountName) forKey:@"data"];
    complete([resultDict mj_JSONString], YES );
}

- (void)getEosBalance:(CompleteBlock)complete{
    WS(weakSelf);
    self.get_table_rows_request.code = self.code;
    self.get_table_rows_request.scope = self.scope;
    self.get_table_rows_request.table = self.table;
    [self.get_table_rows_request postOuterDataSuccess:^(id DAO, id data) {
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
        BalanceModel *model = [BalanceModel mj_objectWithKeyValues: data];
        if ([model.code isEqualToNumber:@0]) {
            [dataDict setValue: VALIDATE_STRING(model.balance) forKey:@"balance"];
            [dataDict setValue: VALIDATE_STRING(weakSelf.code) forKey:@"contract"];
            [dataDict setValue: VALIDATE_STRING(weakSelf.scope) forKey:@"account"];
            [resultDict setValue:dataDict forKey:@"data"];
            [resultDict setValue:@0 forKey:@"code"];
            [resultDict setValue:VALIDATE_STRING(model.message) forKey:@"message"];
        }else{
            [resultDict setValue:@"null" forKey:@"data"];
            [resultDict setValue:VALIDATE_NUMBER(model.code) forKey:@"code"];
            [resultDict setValue:VALIDATE_STRING(model.message) forKey:@"message"];
        }
        
        
        complete([resultDict mj_JSONString], YES );
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)getWalletWithAccount:(CompleteBlock)complete{
    Wallet *wallet = CURRENT_WALLET;
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue: VALIDATE_STRING(self.choosedAccountName) forKey:@"account"];
    [dataDict setValue: VALIDATE_STRING(wallet.wallet_uid) forKey:@"uid"];
    [dataDict setValue: VALIDATE_STRING(wallet.wallet_name) forKey:@"wallet_name"];
    [dataDict setValue: VALIDATE_STRING(wallet.wallet_img) forKey:@"image"];
    [resultDict setValue:dataDict forKey:@"data"];
    [resultDict setValue:@0 forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(@"success") forKey:@"message"];
    complete([resultDict mj_JSONString], YES);
    
}

- (void)getEosAccountInfo:(CompleteBlock)complete{
    self.getAccountRequest.name = VALIDATE_STRING(self.choosedAccountName) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        complete([data mj_JSONString], YES);
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getTransactionById:(CompleteBlock)complete{
    self.getTransactionByIdRequest.transactionId = VALIDATE_STRING(self.transactionIdStr);
    [self.getTransactionByIdRequest getDataSusscess:^(id DAO, id data) {
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        [resultDict setValue: [data objectForKey:@"data"] forKey:@"data"];
        [resultDict setValue: VALIDATE_NUMBER(result.code) forKey:@"code"];
        [resultDict setValue:VALIDATE_STRING(result.msg) forKey:@"message"];
        
        complete([resultDict mj_JSONString], YES);
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)unknownMethod:(CompleteBlock)complete{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setValue:@0 forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(@"Not support") forKey:@"message"];
    [resultDict setValue:VALIDATE_STRING(@"") forKey:@"data"];
    complete([resultDict mj_JSONString], YES );
}


- (NSString *)queryAppVersionInBundle{
    
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    // 当前版本号
    NSString *currentVersionStr =  [infoDic valueForKey:@"CFBundleShortVersionString"];
//    NSString *versionStr = [currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return currentVersionStr;
}
@end
