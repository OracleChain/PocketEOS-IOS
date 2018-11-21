//
//  ImportAccountWithoutAccountNameService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountWithoutAccountNameService.h"

@implementation ImportAccountWithoutAccountNameService


- (void)get_key_accounts:(CompleteBlock)complete{
    WS(weakSelf);
    NSMutableArray *tmpArr = [NSMutableArray array];
    Get_key_accounts_request *get_key_accounts_request = [[Get_key_accounts_request alloc] init];
    get_key_accounts_request.public_key = self.public_key;
    [get_key_accounts_request postOuterDataSuccess:^(id DAO, id data) {
        
        EOSMappingResult *result = [EOSMappingResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            
            for (NSString *accountName in result.account_names) {
                // 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在
                ImportAccountModel *model = [[ImportAccountModel alloc] init];
                model.accountName = accountName;
                
                // 检查本地是否有对应的账号
                AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:accountName];
                if (accountInfo) {
                    model.status = 3;
                }else{
                    model.status = 0;
                }
                
                [tmpArr addObject:model];
            }
            
            complete(tmpArr, YES);
        }else{
            [TOASTVIEW showWithText:result.message];
            complete(nil, NO);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}



@end
