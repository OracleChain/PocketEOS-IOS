//
//  PocketManagementService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PocketManagementService.h"
#import "AccountInfo.h"
#import "SetMainAccountRequest.h"

@interface PocketManagementService()
@property(nonatomic, strong) SetMainAccountRequest *setMainAccountRequest;
@end


@implementation PocketManagementService
- (SetMainAccountRequest *)setMainAccountRequest{
    if (!_setMainAccountRequest) {
        _setMainAccountRequest = [[SetMainAccountRequest alloc] init];
    }
    return _setMainAccountRequest;
}

- (NSMutableDictionary *)dataDictionary{
    if (!_dataDictionary) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}



-(void)buildDataSource:(CompleteBlock)complete{
    NSMutableArray *mainAccountArr = [NSMutableArray array];
    NSMutableArray *othersAccountArr = [NSMutableArray array];
    NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
    [self.dataDictionary removeAllObjects];
    
    for (AccountInfo *model in accountsArr) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            [mainAccountArr addObject:model];
        }else{
            [othersAccountArr addObject:model];
        }
    }
    
    if (mainAccountArr.count > 0) {
        // 有主账号的情况下
        
    }else{
        // 当前没有查到主账号, 可能是被删除了吗,默认设置一个主账号
        for (int i = 0 ; i < accountsArr.count; i++) {
            AccountInfo *model = accountsArr[i];
            if (i == 0) {
                // 将这个账号设为默认的主账号,
                Wallet *wallet = CURRENT_WALLET;
                BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, model.account_name ]];
                // 3. 通知服务器
                self.setMainAccountRequest.uid = CURRENT_WALLET_UID;
                self.setMainAccountRequest.eosAccountName = model.account_name;
                [self.setMainAccountRequest postDataSuccess:^(id DAO, id data) {
                    NSLog(@"通知服务器设置主账号成功!");
                } failure:^(id DAO, NSError *error) {
                    
                }];
                
                [mainAccountArr addObject:model];
                [othersAccountArr removeObject:model];
            }
        }
    }
    // 有主账号的情况下
    [self.dataDictionary setObject:mainAccountArr forKey:@"mainAccount"];
    [self.dataDictionary setObject:othersAccountArr forKey:@"othersAccount"];
    
    
    
    complete(self , YES);
}


@end
