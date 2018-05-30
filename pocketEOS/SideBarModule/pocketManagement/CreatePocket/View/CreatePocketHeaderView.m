//
//  CreatePocketHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CreatePocketHeaderView.h"

@implementation CreatePocketHeaderView


- (IBAction)createPocket:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createPocketBtnDidClick:)]) {
        [self.delegate createPocketBtnDidClick:sender];
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
