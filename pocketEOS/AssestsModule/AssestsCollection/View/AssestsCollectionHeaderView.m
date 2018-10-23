//
//  AssestsCollectionHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionHeaderView.h"

@implementation AssestsCollectionHeaderView

- (IBAction)selectAssestsBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssestBtnDidClick)]) {
        [self.delegate selectAssestBtnDidClick];
    }
}

- (IBAction)allSelectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(allSelectBtnDidClick)]) {
        [self.delegate allSelectBtnDidClick];
    }
}

@end
