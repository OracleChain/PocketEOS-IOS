//
//  BBLoginChooseWalletFooterView.m
//  pocketEOS
//
//  Created by oraclechain on 15/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BBLoginChooseWalletFooterView.h"

@implementation BBLoginChooseWalletFooterView
- (IBAction)confirmBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnDidClick)]) {
        [self.delegate confirmBtnDidClick];
    }
}
- (IBAction)createBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createBtnDidClick)]) {
        [self.delegate createBtnDidClick];
    }
}
- (IBAction)explainBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(explainBtnDidClick)]) {
        [self.delegate explainBtnDidClick];
    }
}
- (IBAction)privacyPolicy:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyBtnDidClick:)]) {
        [self.delegate privacyPolicyBtnDidClick:sender];
    }
}
- (IBAction)agreeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeTermBtnDidClick:)]) {
        [self.delegate agreeTermBtnDidClick:sender];
    }
}


@end
