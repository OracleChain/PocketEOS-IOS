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
#import "ScatterResult_type_requestSignature.h"
#import "Abi_bin_to_jsonRequest.h"
#import "ExcuteActions.h"
#import "Abi_bin_to_json_Result.h"
#import "DappExcuteActionsDataSourceService.h"


@interface DappDetailService()
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@property(nonatomic , strong) GetTransactionByIdRequest *getTransactionByIdRequest;
@property (nonatomic , strong) Get_table_rows_request *get_table_rows_request;

@property(nonatomic , strong) NSMutableArray *finalExcuteActionsArray; // excuteActions add binargs Array
@property(nonatomic , assign) NSInteger abi_bin_to_json_request_count;
@property(nonatomic , strong) Abi_bin_to_jsonRequest *abi_bin_to_jsonRequest;
@property(nonatomic , strong) DappExcuteActionsDataSourceService *dappExcuteActionsDataSourceService;


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

- (NSMutableArray *)finalExcuteActionsArray{
    if (!_finalExcuteActionsArray) {
        _finalExcuteActionsArray = [[NSMutableArray alloc] init];
    }
    return _finalExcuteActionsArray;
}

- (DappExcuteActionsDataSourceService *)dappExcuteActionsDataSourceService{
    if (!_dappExcuteActionsDataSourceService) {
        _dappExcuteActionsDataSourceService = [[DappExcuteActionsDataSourceService alloc] init];
    }
    return _dappExcuteActionsDataSourceService;
}

- (Abi_bin_to_jsonRequest *)abi_bin_to_jsonRequest{
    if (!_abi_bin_to_jsonRequest) {
        _abi_bin_to_jsonRequest = [[Abi_bin_to_jsonRequest alloc] init];
    }
    return _abi_bin_to_jsonRequest;
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

// scatter
- (void)requestScatterSignature:(CompleteBlock)complete{
    
    self.requestSignature_scatterResult = [ScatterResult_type_requestSignature mj_objectWithKeyValues:self.scatter_request_signatureStr];
    [self buildAbi_bin_to_jsonDataSource];
    complete(@"hahaha", YES );
}



- (void)buildAbi_bin_to_jsonDataSource{
    WS(weakSelf);
    self.abi_bin_to_json_request_count = 0;
    NSMutableArray *tmp = [NSMutableArray array];
    NSArray *actionsArray = self.requestSignature_scatterResult.actions;
    for (int i = 0 ; i < actionsArray.count; i++) {
        NSDictionary *dict = actionsArray[i];
        ExcuteActions *action = [ExcuteActions mj_objectWithKeyValues:dict];
        action.tag = [NSString stringWithFormat:@"action%d", i];
        
        self.abi_bin_to_jsonRequest.code = action.account;
        self.abi_bin_to_jsonRequest.action = action.name;
        self.abi_bin_to_jsonRequest.binargs = dict[@"data"];
        
        AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] init];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Accept"];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
        outerNetworkingManager.requestSerializer=[AFJSONRequestSerializer serializer];
        [outerNetworkingManager.requestSerializer setValue: action.tag forHTTPHeaderField: @"From"];
        
        [outerNetworkingManager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript", nil]];


        NSString *url = [NSString stringWithFormat:@"%@/api_oc_blockchain-v1.3.0/abi_bin_to_json", REQUEST_HTTP_BASEURL];


        [outerNetworkingManager POST: url parameters: [self.abi_bin_to_jsonRequest parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *HTTPHeaderFieldFromValue = [outerNetworkingManager.requestSerializer valueForHTTPHeaderField:@"From"];
            NSLog(@"responseObject: %@,HTTPHeaderFieldFromValue: %@", responseObject, HTTPHeaderFieldFromValue);
            Abi_bin_to_json_Result *abi_bin_to_json_result = [Abi_bin_to_json_Result mj_objectWithKeyValues:responseObject];
            
            if ([abi_bin_to_json_result.code isEqualToNumber:@0]) {
                if ([HTTPHeaderFieldFromValue isEqualToString:action.tag]) {
                    action.data = abi_bin_to_json_result.data.args;
                    weakSelf.abi_bin_to_json_request_count ++;
                    [tmp addObject:action];
                    
                    if (weakSelf.abi_bin_to_json_request_count == actionsArray.count) {
                        weakSelf.finalExcuteActionsArray =  (NSMutableArray *)[tmp sortedArrayUsingComparator:^NSComparisonResult(ExcuteActions  *obj1, ExcuteActions *obj2) {
                            return [obj1.tag compare:obj2.tag options:(NSCaseInsensitiveSearch)];
                        }];
                        
                        [weakSelf buildExcuteActionsDataSource];
                    }
                }
            }else{
                NSLog(@"%@",abi_bin_to_json_result.message );
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }

}

- (void)buildExcuteActionsDataSource{
    WS(weakSelf);
    NSMutableArray *actionsArr = [NSMutableArray array];
    for (int i = 0 ; i < self.finalExcuteActionsArray.count; i++) {
        ExcuteActions *action = self.finalExcuteActionsArray[i];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
        [actionDict setObject:VALIDATE_STRING(action.account) forKey:@"account"];
        [actionDict setObject:VALIDATE_STRING(action.name) forKey:@"name"];
        [actionDict setObject:IsNilOrNull(action.data) ? @{} : action.data forKey:@"data"];
        [actionDict setObject:IsNilOrNull(action.authorization) ? @[] : action.authorization forKey:@"authorization"];
        [actionsArr addObject:actionDict];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Scatter_ExcuteActions" forKey:@"type"];
    [dict setObject:VALIDATE_ARRAY(actionsArr) forKey:@"actions"];
    
    self.dappExcuteActionsDataSourceService.actionsResultDict = [dict mj_JSONString];
    [self.dappExcuteActionsDataSourceService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            for (ExcuteActions *action in weakSelf.dappExcuteActionsDataSourceService.dataSourceArray) {
                NSLog(@"scatterBuildExcuteActionsDataSourceAction :%@", [action mj_JSONString]);
            }
            
            
            NSLog(@"%@", weakSelf.requestSignature_scatterResult.mj_JSONString);
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scatterBuildExcuteActionsDataSourceDidSuccess:)]) {
                [weakSelf.delegate scatterBuildExcuteActionsDataSourceDidSuccess:weakSelf.dappExcuteActionsDataSourceService.dataSourceArray];
            }
//            [weakSelf.view addSubview:weakSelf.dAppExcuteMutipleActionsBaseView];
//            [weakSelf.dAppExcuteMutipleActionsBaseView updateViewWithArray:weakSelf.dappExcuteActionsDataSourceService.dataSourceArray];
        }
    }];
    
}












- (NSString *)queryAppVersionInBundle{
    
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    // 当前版本号
    NSString *currentVersionStr =  [infoDic valueForKey:@"CFBundleShortVersionString"];
//    NSString *versionStr = [currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return currentVersionStr;
}

@end
