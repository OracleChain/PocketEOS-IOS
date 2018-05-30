//
//  BBLoginCreateWalletView.m
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BBLoginCreateWalletView.h"

@interface BBLoginCreateWalletView()

@end


@implementation BBLoginCreateWalletView


- (IBAction)nextStepBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextStepBtnDidClick)]) {
        [self.delegate nextStepBtnDidClick];
    }
}

- (IBAction)explainBlackBoxMode:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(explainBlackBoxModeBtnDidClick)]) {
        [self.delegate explainBlackBoxModeBtnDidClick];
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
