//
//  PhoneLoginMainView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PhoneLoginMainView.h"

@implementation PhoneLoginMainView


- (IBAction)getVerifyCodeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyBtnDidClick:)]) {
        [self.delegate getVerifyBtnDidClick:sender];
    }
}

- (IBAction)loginBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginBtnDidClick:)]) {
        [self.delegate loginBtnDidClick:sender];
    }
}

- (IBAction)areaCodeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaCodeBtnDidClick)]) {
        [self.delegate areaCodeBtnDidClick];
    }
    
}


@end
