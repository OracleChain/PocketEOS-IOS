//
//  WalletUtil.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "WalletUtil.h"
#import "SetMainAccountRequest.h"

@interface WalletUtil()
@end


@implementation WalletUtil

+ (BOOL)validateWalletPasswordWithSha256:(NSString *)sha256 password:(NSString *)password{
    if (sha256.length < 32) {
        return NO;
    }
    NSString *passwordSha256 =  [sha256 substringFromIndex:32];
    NSString *randomStr = [sha256 substringToIndex:32];
    NSString *decryptStr = [NSString stringWithFormat:@"%@%@",randomStr,password];
    NSString *newSha256 = [decryptStr sha256];
    if ([newSha256 isEqualToString:passwordSha256]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)generate_wallet_shapwd_withPassword:(NSString *)password{
    NSString *randomStr = [NSString randomStringWithLength:32];
    NSString *encryptStr = [NSString stringWithFormat:@"%@%@", randomStr,password];
    NSString *password_sha256 = [encryptStr sha256];
    NSString *savePassword = [NSString stringWithFormat:@"%@%@", randomStr,password_sha256];
    return savePassword;
}



+ (void)setMainAccountWithAccountInfoModel:(AccountInfo *)accountInfo{
    NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
    Wallet *wallet = CURRENT_WALLET;
    if (accountsArr.count == 1) {
        // 当前只有一个账号既设置为主账号
        // notice server
        SetMainAccountRequest *setMainAccountRequest = [[SetMainAccountRequest alloc] init];
        setMainAccountRequest.uid = CURRENT_WALLET_UID;
        setMainAccountRequest.eosAccountName = accountInfo.account_name;
        [setMainAccountRequest postDataSuccess:^(id DAO, id data) {
            BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
            if ([result.code isEqualToNumber:@0]) {
                // 1.将所有的账号都设为 非主账号
                [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_main_account = '0' ", wallet.account_info_table_name]];
                
                // update account table
                BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, accountInfo.account_name ]];
                
                // update wallet table
                [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET wallet_main_account = '%@' WHERE wallet_uid = '%@'" , WALLET_TABLE , accountInfo.account_name, CURRENT_WALLET_UID]];
                NSLog(@"设置主账号成功");
            }else{
                [TOASTVIEW showWithText:result.message];
            }
        } failure:^(id DAO, NSError *error) {
            
        }];
    }else{
        NSLog(@"已有本地主账号");
        // update account table
        BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '0'  WHERE account_name = '%@'", wallet.account_info_table_name, accountInfo.account_name ]];
    }
}





@end
