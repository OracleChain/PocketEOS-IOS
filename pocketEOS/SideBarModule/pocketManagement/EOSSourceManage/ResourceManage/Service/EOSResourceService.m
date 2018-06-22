//
//  EOSResourceService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceService.h"


@implementation EOSResourceService

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}
//
//- (EOSResourceResult *)eosResourceResult{
//    if (!_eosResourceResult) {
//        _eosResourceResult = [[EOSResourceResult alloc] init];
//    }
//    return _eosResourceResult;
//}


/**
 账号资产详情
 */
- (void)get_account:(CompleteBlock)complete{
    WS(weakSelf);
    
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            weakSelf.eosResourceResult = [EOSResourceResult mj_objectWithKeyValues:data];
            
            if (![weakSelf.eosResourceResult.code isEqualToNumber:@0]) {
                [TOASTVIEW showWithText: VALIDATE_STRING(weakSelf.eosResourceResult.message)];
                return ;
            }
            
            EOSResourceCellModel *cpu_model = [[EOSResourceCellModel alloc] init];
            cpu_model.title = NSLocalizedString(@"CPU带宽", nil);
            cpu_model.used = weakSelf.eosResourceResult.data.cpu_used;
            cpu_model.available = weakSelf.eosResourceResult.data.cpu_available;
            cpu_model.max = weakSelf.eosResourceResult.data.cpu_max;
            cpu_model.weight = weakSelf.eosResourceResult.data.cpu_weight;
            
            EOSResourceCellModel *net_model = [[EOSResourceCellModel alloc] init];
            net_model.title = NSLocalizedString(@"net带宽", nil);
            net_model.used = weakSelf.eosResourceResult.data.net_used;
            net_model.available = weakSelf.eosResourceResult.data.net_available;
            net_model.max = weakSelf.eosResourceResult.data.net_max;
            net_model.weight = weakSelf.eosResourceResult.data.net_weight;
            
            weakSelf.dataSourceArray = [NSMutableArray arrayWithObjects:cpu_model, net_model, nil];
            complete(weakSelf.eosResourceResult, YES);
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
        complete(nil, NO);
    }];
}


@end
