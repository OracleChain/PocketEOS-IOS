//
//  ImportAccountWithoutAccountNameDoublePrivateKeyModeHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountWithoutAccountNameDoublePrivateKeyModeHeaderView.h"


@interface ImportAccountWithoutAccountNameDoublePrivateKeyModeHeaderView ()

@property (weak, nonatomic) IBOutlet BaseLabel1 *tipLabel;

@property (weak, nonatomic) IBOutlet BaseConfirmButton *confirmBtn;

@end

@implementation ImportAccountWithoutAccountNameDoublePrivateKeyModeHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.textView1.contentInset = UIEdgeInsetsMake(MARGIN_10, MARGIN_15, MARGIN_10, MARGIN_15);
    self.textView2.contentInset = UIEdgeInsetsMake(MARGIN_10, MARGIN_15, MARGIN_10, MARGIN_15);
    
    self.tipLabel.text = NSLocalizedString(@"请分别输入Owner私钥和Active私钥：", nil);
    [self.confirmBtn setTitle:NSLocalizedString(@"确认",  nil) forState:(UIControlStateNormal)];
    
    self.textView1.placeholder = NSLocalizedString(@"请输入私钥：", nil);
    self.textView2.placeholder = NSLocalizedString(@"请输入私钥：", nil);
}


- (IBAction)confirmBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountWithoutAccountNameDoublePrivateKeyModeHeaderViewConfirmBtnDidClick)]) {
        [self.delegate importAccountWithoutAccountNameDoublePrivateKeyModeHeaderViewConfirmBtnDidClick];
    }
}

@end
