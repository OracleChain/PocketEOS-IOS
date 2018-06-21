//
//  EOSResourceService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceService.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"


@implementation EOSResourceService

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}
/**
 账号资产详情
 */
- (void)get_account:(CompleteBlock)complete{
    WS(weakSelf);
    
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            EOSResourceResult *result = [EOSResourceResult mj_objectWithKeyValues:data];
            
            if (![result.code isEqualToNumber:@0]) {
                [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
                return ;
            }
            
            EOSResourceCellModel *cpu_model = [[EOSResourceCellModel alloc] init];
            cpu_model.title = NSLocalizedString(@"CPU带宽", nil);
            cpu_model.used = result.data.cpu_used;
            cpu_model.available = result.data.cpu_available;
            cpu_model.max = result.data.cpu_max;
            cpu_model.weight = result.data.cpu_weight;
            
            EOSResourceCellModel *net_model = [[EOSResourceCellModel alloc] init];
            net_model.title = NSLocalizedString(@"net带宽", nil);
            net_model.used = result.data.net_used;
            net_model.available = result.data.net_available;
            net_model.max = result.data.net_max;
            net_model.weight = result.data.net_weight;
            
            weakSelf.dataSourceArray = [NSMutableArray arrayWithObjects:cpu_model, net_model, nil];
            complete(result, YES);
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
        complete(nil, NO);
    }];
}


@end
