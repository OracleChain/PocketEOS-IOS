//
//  RecieveHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RecieveHeaderView.h"

@implementation RecieveHeaderView

- (IBAction)selectAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAccountBtnDidClick:)]) {
        [self.delegate selectAccountBtnDidClick: sender];
    }
}
- (IBAction)selectAssests:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssestsBtnDidClick:)]) {
        [self.delegate selectAssestsBtnDidClick: sender];
    }
}

- (IBAction)createQRCode:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createQRCodeBtnDidClick:)]) {
        [self.delegate createQRCodeBtnDidClick: sender];
    }
}

@end
