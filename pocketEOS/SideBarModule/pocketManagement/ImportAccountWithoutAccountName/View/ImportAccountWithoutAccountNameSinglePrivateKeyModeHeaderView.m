//
//  ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView.h"

@interface ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView ()
@property (weak, nonatomic) IBOutlet BaseLabel1 *tipLabel;

@property (weak, nonatomic) IBOutlet BaseConfirmButton *confirmBtn;

@end

@implementation ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textView.contentInset = UIEdgeInsetsMake(MARGIN_10, MARGIN_15, MARGIN_10, MARGIN_15);
    self.tipLabel.text = NSLocalizedString(@"请输入私钥：", nil);
    self.textView.placeholder = NSLocalizedString(@"请输入私钥：", nil);
    [self.confirmBtn setTitle:NSLocalizedString(@"确认",  nil) forState:(UIControlStateNormal)];
}

- (IBAction)confirmBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountWithoutAccountNameSinglePrivateKeyModeHeaderViewConfirmBtnDidClick)]) {
        [self.delegate importAccountWithoutAccountNameSinglePrivateKeyModeHeaderViewConfirmBtnDidClick];
    }
}


@end
