//
//  ImportAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ImportAccountHeaderView.h"



@implementation ImportAccountHeaderView

- (IBAction)import:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importBtnDidClick:)]) {
        [self.delegate importBtnDidClick:sender];
    }
}

- (IBAction)agreeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeTermBtnDidClick:)]) {
        [self.delegate agreeTermBtnDidClick:sender];
    }
}
@end
