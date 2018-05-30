//
//  TransferHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "TransferHeaderView.h"
#import "UITextView+Placeholder.h"

@interface TransferHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *selectAccountsBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAssestsBtn;

@end

@implementation TransferHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.memoTV.placeholder = @"恭喜发财, 大吉大利";
    
    self.memoTV.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF8F8F8))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1))
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.6));
}

- (IBAction)selectAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAccountBtnDidClick:)]) {
        [self.delegate selectAccountBtnDidClick: sender];
    }
}

- (IBAction)selectAssests:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssestsBtnDidClick:)]) {
        [self.delegate selectAssestsBtnDidClick: sender];
    }
}

- (IBAction)contactBtnDidClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactBtnDidClick:)]) {
        [self.delegate contactBtnDidClick: sender];
    }
}

- (IBAction)transferBtnDidClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(transferBtnDidClick:)]) {
        [self.delegate transferBtnDidClick: sender];
    }
}

@end
