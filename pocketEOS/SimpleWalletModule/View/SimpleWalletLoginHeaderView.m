//
//  SimpleWalletLoginHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SimpleWalletLoginHeaderView.h"

@implementation SimpleWalletLoginHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
}


- (IBAction)confirmAuthorizationBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmAuthorizationBtnDidClick)]) {
        [self.delegate confirmAuthorizationBtnDidClick];
    }
}


@end
