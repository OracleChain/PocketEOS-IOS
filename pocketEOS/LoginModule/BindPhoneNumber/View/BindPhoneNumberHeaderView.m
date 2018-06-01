//
//  BindPhoneNumberHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BindPhoneNumberHeaderView.h"

@implementation BindPhoneNumberHeaderView

- (IBAction)getVerifyCodeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyCodeBtnDidClick:)]) {
        [self.delegate getVerifyCodeBtnDidClick:sender];
    }
}

- (IBAction)bindBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindBtnDidClick:)]) {
        [self.delegate bindBtnDidClick:sender];
    }
}

- (IBAction)privacyPolicy:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyBtnDidClick:)]) {
        [self.delegate privacyPolicyBtnDidClick:sender];
    }
}
- (IBAction)agreeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
@end
