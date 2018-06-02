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
@property (weak, nonatomic) IBOutlet UIView *memoBaseView;

@end

@implementation TransferHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.memoTV.placeholder = @"恭喜发财, 大吉大利";
    self.assest_balanceLabel.font = [UIFont boldSystemFontOfSize:14];
    self.assest_balance_ConvertLabel.font = [UIFont boldSystemFontOfSize:14];
    self.amount_ConvertLabel.font = [UIFont boldSystemFontOfSize:24];
    
    self.memoBaseView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF8F8F8))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
    
    
    self.memoTV.lee_theme
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 1));
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.memoTV.placeholderColor = HEX_RGB_Alpha(0x666666, 1);
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.memoTV.placeholderColor = HEXCOLOR(0xFFFFFF);
    }
    
    self.transferBtn.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xCCCCCC))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
    
//    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF8F8F8))
//    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1))
    
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
