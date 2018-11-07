//
//  AssestsCollectionMainService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionMainService.h"
#import "Get_account_assetsResult.h"
#import "AccountInfo.h"

@implementation AssestsCollectionMainService

- (Get_account_assetsRequest *)get_account_assetsRequest{
    if (!_get_account_assetsRequest) {
        _get_account_assetsRequest = [[Get_account_assetsRequest alloc] init];
    }
    return _get_account_assetsRequest;
}


- (void)buildDataSource:(CompleteBlock)complete{
    NSArray *accountInfoArr = [[AccountsTableManager accountTable] selectAccountTable];
    NSMutableArray *paramsArr = [NSMutableArray array];
    for (AccountInfo *accountInfo in accountInfoArr) {
        if ([accountInfo.is_main_account isEqualToString:@"0"]) {
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:VALIDATE_STRING(accountInfo.account_name) forKey:@"account_name"];
            [paramDic setObject:VALIDATE_STRING(self.currentToken.contract_name) forKey:@"contract_name"];
            [paramDic setObject:VALIDATE_STRING(self.currentToken.token_symbol) forKey:@"token_symbol"];
            [paramDic setObject:VALIDATE_STRING(self.currentToken.coinmarket_id) forKey:@"coinmarket_id"];
            [paramsArr addObject:paramDic];
            
        }
    }
    
    WS(weakSelf);
    self.get_account_assetsRequest.accountInfoArr = paramsArr;
    [self.get_account_assetsRequest postOuterDataSuccess:^(id DAO, id data) {
        Get_account_assetsResult *result = [Get_account_assetsResult mj_objectWithKeyValues:data];
        weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:result.user_asset_list];
        if (weakSelf.dataSourceArray.count == 0) {
            [TOASTVIEW showWithText: NSLocalizedString(@"只有主账号,无法进行资产归集", nil)];
        }
        complete(weakSelf, YES);
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)buildExcuteActionsArrayWithTransferModel:(NSArray<CommonTransferModel *> *)modelArr andComplete:(CompleteBlock)complete{
    [self.dataSourceArray removeAllObjects];
    for (int i = 0; i < modelArr.count; i++) {
        CommonTransferModel *model = modelArr[i];
        ExcuteActions *action = [self constractExcuteActionsWithModel:model];
        [self.dataSourceArray addObject:action];
    }
    complete(self , YES);
}


- (ExcuteActions *)constractExcuteActionsWithModel:(CommonTransferModel *)model{
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:VALIDATE_STRING(model.from) forKey:@"actor"];
    [authorizationDict setObject:VALIDATE_STRING(@"active") forKey:@"permission"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:VALIDATE_STRING(model.from) forKey:@"from"];
    [dataDict setObject:VALIDATE_STRING(model.to) forKey:@"to"];
    [dataDict setObject:[NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", model.precision.intValue, model.amount.doubleValue], model.symbol] forKey:@"quantity"];
    [dataDict setObject:VALIDATE_STRING(model.memo) forKey:@"memo"];
    
    [actionDict setObject:VALIDATE_STRING(model.contract) forKey:@"account"];
    [actionDict setObject:ContractAction_TRANSFER forKey:@"name"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [actionDict setObject:dataDict forKey:@"data"];
    
    ExcuteActions *action = [ExcuteActions mj_objectWithKeyValues:actionDict];
    action.actor = model.from;
    action.to = model.to;
    return action;
}

@end
