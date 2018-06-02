//
//  PocketManagementHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PocketManagementHeaderView.h"

@interface PocketManagementHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *createAccountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *importAccountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backupWalletImageView;
@property (weak, nonatomic) IBOutlet UIImageView *changePasswordImageView;

@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;

@end


@implementation PocketManagementHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headerBackgroundView.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEX_RGB(0xFFF7EA)).LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.12));
    
    self.tipTextView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEX_RGB(0xFFF7EA))
    .LeeAddBackgroundColor(BLACKBOX_MODE, [UIColor clearColor])
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0xFFB540))
    .LeeAddTextColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.6));
    self.createAccountImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"createAccount"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"createAccount_BB"]);
    self.importAccountImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"importAccount"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"importAccount_BB"]);
    self.backupWalletImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"backup"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"backup_BB"]);
    self.changePasswordImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"changePassword"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"changePassword_BB"]);
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSString *tipStr = @"1. 请务必备份好自己的钱包，或单分别导出账号（明文）妥善保管\n2.账号私钥将被加密保管在手机里\n3.选择远程托管将把加密的账号备份至pE的服务器\n4.选择保护隐私，别人将无法通过钱包名称查到此账号\n5.当更换手机时，请务必销毁钱包";
    
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     ,
                                     NSForegroundColorAttributeName : HEXCOLOR(0xFFB540 )
                                     };
        self.tipTextView.attributedText = [[NSAttributedString alloc] initWithString:tipStr attributes:attributes];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     ,
                                     NSForegroundColorAttributeName : HEX_RGB_Alpha(0xFFFFFF, 0.6)
                                     };
        self.tipTextView.attributedText = [[NSAttributedString alloc] initWithString:tipStr attributes:attributes];

    }
    
    
    
}

- (IBAction)createAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createAccountBtnDidClick:)]) {
        [self.delegate createAccountBtnDidClick:sender];
    }
}

- (IBAction)importAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountBtnDidClick:)]) {
        [self.delegate importAccountBtnDidClick:sender];
    }
}
- (IBAction)backupPocket:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backupPocketBtnDidClick:)]) {
        [self.delegate backupPocketBtnDidClick:sender];
    }
    
    
}

- (IBAction)changePassword:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePasswordBtnDidClick:)]) {
        [self.delegate changePasswordBtnDidClick:sender];
    }
}
- (IBAction)mainAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainAccountBtnDidClick:)]) {
        [self.delegate mainAccountBtnDidClick:sender];
    }
}

@end
