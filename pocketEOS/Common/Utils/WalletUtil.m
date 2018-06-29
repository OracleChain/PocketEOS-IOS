//
//  WalletUtil.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "WalletUtil.h"

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

@end
