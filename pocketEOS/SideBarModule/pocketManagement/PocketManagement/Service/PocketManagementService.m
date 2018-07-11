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
            
            if ([model.account_name isEqualToString:self.currentAccountName]) {
                model.selected = YES;
            }
            
            [mainAccountArr addObject:model];
        }else{
            if ([model.account_name isEqualToString:self.currentAccountName]) {
                model.selected = YES;
            }
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
                
                if ([model.account_name isEqualToString:self.currentAccountName]) {
                    model.selected = YES;
                }
               
                //  通知服务器
                self.setMainAccountRequest.uid = CURRENT_WALLET_UID;
                self.setMainAccountRequest.eosAccountName = model.account_name;
                [self.setMainAccountRequest postDataSuccess:^(id DAO, id data) {
                    BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
                    if ([result.code isEqualToNumber:@0]) {
                        // 1.将所有的账号都设为 非主账号
                        Wallet *wallet = CURRENT_WALLET;
                        [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_main_account = '0' ", wallet.account_info_table_name]];
                        
                        // update account table
                        BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, model.account_name ]];
                        
                        // update wallet table
                        [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET wallet_main_account = '%@' WHERE wallet_uid = '%@'" , WALLET_TABLE , model.account_name, CURRENT_WALLET_UID]];
                        NSLog(@"设置主账号成功");
                    }else{
                        [TOASTVIEW showWithText:result.message];
                    }
                    
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
    
    
    
    
    // services
     NSMutableArray *itemArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"创建账号", nil), NSLocalizedString(@"导入账号", nil), NSLocalizedString(@"修改密码", nil), NSLocalizedString(@"备份钱包", nil), nil];
    NSMutableArray *iconArr = [NSMutableArray arrayWithObjects:@"createAccount", @"importAccount", @"changePassword", @"backup",nil];
    NSMutableArray *iconArr_BB = [NSMutableArray arrayWithObjects:@"createAccount_BB", @"importAccount_BB", @"changePassword_BB", @"backup_BB",nil];
    NSMutableArray *servicesArr = [NSMutableArray array];
    for (int i = 0; i < itemArr.count; i++) {
        OptionModel *model = [[OptionModel alloc] init];
        model.optionName = itemArr[i];
        model.optionNormalIcon = iconArr[i];
        model.optionSelectedIcon = iconArr_BB[i];
        [servicesArr addObject:model];
    }
    [self.dataDictionary setObject:servicesArr forKey:@"servicesArr"];
    complete(self , YES);
}


@end
