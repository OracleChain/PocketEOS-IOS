//
//  ImportAccountPermisionHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountPermisionHeaderView.h"

@interface ImportAccountPermisionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@end

@implementation ImportAccountPermisionHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.confirmBtn setTitle:NSLocalizedString(@"导入", nil) forState:(UIControlStateNormal)];
    
    
    self.textView.placeholder = NSLocalizedString(@"请输入私钥：", nil);
}

- (IBAction)resetPrivateKeyBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountPermisionHeaderViewResetPrivateKeyBtnDidClick)]) {
        [self.delegate importAccountPermisionHeaderViewResetPrivateKeyBtnDidClick];
    }
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountPermisionHeaderViewConfirmBtnDidClick)]) {
        [self.delegate importAccountPermisionHeaderViewConfirmBtnDidClick];
    }
    
}


@end
