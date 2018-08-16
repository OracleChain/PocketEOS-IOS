//
//  ImportAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ImportAccountHeaderView.h"

@interface ImportAccountHeaderView()


@end


@implementation ImportAccountHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.private_activeKey_tf.placeholder = NSLocalizedString(@"输入Active私钥", nil);
    self.private_ownerKey_TF.placeholder = NSLocalizedString(@"输入Owner私钥", nil);
    
}

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
