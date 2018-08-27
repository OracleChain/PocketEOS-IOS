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
@property (weak, nonatomic) IBOutlet UIButton *selectAssestsBtn;
@property (weak, nonatomic) IBOutlet UIView *memoBaseView;

@end

@implementation TransferHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.memoTV.placeholder = NSLocalizedString(@"请在此输入memo", nil);
    self.assest_balanceLabel.font = [UIFont boldSystemFontOfSize:14];
    self.assest_balance_ConvertLabel.font = [UIFont boldSystemFontOfSize:14];
    self.amount_ConvertLabel.font = [UIFont boldSystemFontOfSize:24];
    
    self.memoBaseView.lee_theme
    .LeeConfigBackgroundColor(@"baseView_background_color");
    
    
    self.memoTV.lee_theme
    .LeeConfigTextColor(@"common_font_color_1");
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.memoTV.placeholderColor = HEX_RGB_Alpha(0x666666, 1);
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.memoTV.placeholderColor = HEXCOLOR(0xFFFFFF);
    }
    
    self.transferBtn.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xCCCCCC))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
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
