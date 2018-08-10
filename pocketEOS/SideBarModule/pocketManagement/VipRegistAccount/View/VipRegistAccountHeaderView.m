//
//  VipRegistAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "VipRegistAccountHeaderView.h"

@implementation VipRegistAccountHeaderView

- (IBAction)confirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createBtnDidClick:)]) {
        [self.delegate createBtnDidClick:sender];
    }
}

- (IBAction)privateKeyBeSameModeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(privateKeyBeSameModeBtnDidClick:)]) {
        [self.delegate privateKeyBeSameModeBtnDidClick:sender];
    }
}

- (IBAction)privateKeyBeDiffrentModeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(privateKeyBeDiffrentModeBtnDidClick:)]) {
        [self.delegate privateKeyBeDiffrentModeBtnDidClick:sender];
    }
}




@end
