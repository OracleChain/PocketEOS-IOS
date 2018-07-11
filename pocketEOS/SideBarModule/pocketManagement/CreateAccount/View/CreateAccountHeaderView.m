//
//  CreateAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "CreateAccountHeaderView.h"

@interface CreateAccountHeaderView()
@property (weak, nonatomic) IBOutlet BaseTextView *tipTextView;

@end


@implementation CreateAccountHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tipTextView.placeholder = NSLocalizedString(@"备份提示：由于区块链的去中心化特性，EOS账号一旦丢失将无法找回。创建账号后请根据下页的提示妥善备份，以防账号丢失带来的损失。", nil);
}

- (IBAction)agreeTermBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeTermBtnDidClick:)]) {
        [self.delegate agreeTermBtnDidClick:sender];
    }
    
}
- (IBAction)createAccount:(UIButton *)sender {
//    sender.selected = !sender.isSelecteXd;
    if (self.delegate && [self.delegate respondsToSelector:@selector(createAccountBtnDidClick:)]) {
        [self.delegate createAccountBtnDidClick:sender];
    }
}
- (IBAction)privacyPolicy:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyBtnDidClick:)]) {
        [self.delegate privacyPolicyBtnDidClick:sender];
    }
}


@end
