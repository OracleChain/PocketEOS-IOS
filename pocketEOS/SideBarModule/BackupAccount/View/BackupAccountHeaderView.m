//
//  BackupAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//



#import "BackupAccountHeaderView.h"
#import "ExportPrivateKeyView.h"
#import "AccountInfo.h"

@interface BackupAccountHeaderView()<ExportPrivateKeyViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;


@property (weak, nonatomic) IBOutlet UIImageView *backupImageView;

@property(nonatomic , assign) BOOL isSwitchOn;
@property(nonatomic, strong) ExportPrivateKeyView *exportPrivateKeyView;

@end


@implementation BackupAccountHeaderView


- (ExportPrivateKeyView *)exportPrivateKeyView{
    if (!_exportPrivateKeyView) {
        _exportPrivateKeyView = [[[NSBundle mainBundle] loadNibNamed:@"ExportPrivateKeyView" owner:nil options:nil] firstObject];
        _exportPrivateKeyView.frame = [UIScreen mainScreen].bounds;
        _exportPrivateKeyView.delegate = self;
    }
    return _exportPrivateKeyView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.frame = self.contentBackgroundView.bounds;
        _contentTextView.lee_theme
        .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
        .LeeAddTextColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF))
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF0F3F5))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
    }
    return _contentTextView;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentBackgroundView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF0F3F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
    self.tipTextView.lee_theme
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.6));
    
    self.backupImageView.lee_theme
    .LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"shield_BB"])
    .LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"shield"]);

    
}

- (IBAction)confirmSwitch:(UISwitch *)sender {
    self.isSwitchOn = YES;
    
    for (UIView *subView in self.contentBackgroundView.subviews) {
        [subView removeFromSuperview];
    }
    [self.contentBackgroundView addSubview:self.contentTextView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmSwitchDidOn)]) {
        [self.delegate confirmSwitchDidOn];
    }
    
   
    
}

- (IBAction)confirmBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backupConfirmBtnDidClick)]) {
        [self.delegate backupConfirmBtnDidClick];
    }
}

@end
