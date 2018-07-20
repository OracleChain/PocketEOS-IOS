//
//  PocketManagementHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PocketManagementHeaderView.h"

@implementation PocketManagementHeaderView

- (IBAction)createAccountBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createAccountBtnDidClick)]) {
        [self.delegate createAccountBtnDidClick];
    }
}

- (IBAction)importAccountBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountBtnDidClick)]) {
        [self.delegate importAccountBtnDidClick];
    }
}

- (IBAction)changePasswordBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePasswordBtnDidClick)]) {
        [self.delegate changePasswordBtnDidClick];
    }
}

- (IBAction)backupWalletBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backupWalletBtnDidClick)]) {
        [self.delegate backupWalletBtnDidClick];
    }
    
}

@end
