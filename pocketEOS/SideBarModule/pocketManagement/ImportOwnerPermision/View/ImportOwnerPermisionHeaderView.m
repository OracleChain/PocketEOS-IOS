//
//  ImportOwnerPermisionHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/30.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportOwnerPermisionHeaderView.h"

@implementation ImportOwnerPermisionHeaderView

- (IBAction)import:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importBtnDidClick:)]) {
        [self.delegate importBtnDidClick:sender];
    }
}

@end
