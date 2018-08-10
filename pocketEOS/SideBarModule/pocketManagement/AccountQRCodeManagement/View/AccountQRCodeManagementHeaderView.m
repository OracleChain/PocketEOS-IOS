
//
//  AccountQRCodeManagementHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AccountQRCodeManagementHeaderView.h"



@implementation AccountQRCodeManagementHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
}

- (IBAction)copyNameBtnClick:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyNameBtnClick)]) {
        [self.delegate copyNameBtnClick];
    }
}


@end
