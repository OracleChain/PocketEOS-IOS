//
//  CreateAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "CreateAccountHeaderView.h"

@implementation CreateAccountHeaderView
- (IBAction)agreeTermBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeTermBtnDidClick:)]) {
        [self.delegate agreeTermBtnDidClick:sender];
    }
    
}
- (IBAction)createAccount:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(createAccountBtnDidClick:)]) {
        [self.delegate createAccountBtnDidClick:sender];
    }
}
- (IBAction)privacyPolicy:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyBtnDidClick:)]) {
        [self.delegate privacyPolicyBtnDidClick:sender];
    }
}


@end
