//
//  ResetAccountPermisionHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ResetAccountPermisionHeaderView.h"

@interface ResetAccountPermisionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *generatePrivateKeyBtn;
@property (weak, nonatomic) IBOutlet BaseLabel1 *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ResetAccountPermisionHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.generatePrivateKeyBtn setTitle:NSLocalizedString(@"生成密钥", nil) forState:(UIControlStateNormal)];
    self.tipLabel.text = NSLocalizedString(@"注意: \n为避免权限变更失败导致账号不可用，变更权限前请备份原私钥；", nil);
    [self.confirmBtn setTitle:NSLocalizedString(@"变更", nil) forState:(UIControlStateNormal)];
    self.textView.placeholder = NSLocalizedString(@"请输入私钥：", nil);
}

- (IBAction)generatePrivateKeyBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetAccountPermisionHeaderViewGeneratePrivateKeyBtnDidClick)]) {
        [self.delegate resetAccountPermisionHeaderViewGeneratePrivateKeyBtnDidClick];
    }
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetAccountPermisionHeaderViewConfirmBtnDidClick)]) {
        [self.delegate resetAccountPermisionHeaderViewConfirmBtnDidClick];
    }
}


@end
