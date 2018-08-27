//
//  RedPacketHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RedPacketHeaderView.h"
#import "UITextView+Placeholder.h"

@interface RedPacketHeaderView()
@property (weak, nonatomic) IBOutlet UIView *memoBaseView;

@end


@implementation RedPacketHeaderView

- (IBAction)selectAssests:(UIButton *)sender {
    [sender setSelected: !sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssestsBtnDidClick:)]) {
        [self.delegate selectAssestsBtnDidClick: sender];
    }
}


- (IBAction)sendRedPacket:(UIButton *)sender {
     [sender setSelected: !sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendRedPacket:)]) {
        [self.delegate sendRedPacket:sender];
    }
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.tipLabel.font = [UIFont boldSystemFontOfSize:24];
    
    self.memoBaseView.lee_theme
    .LeeConfigBackgroundColor(@"baseView_background_color");
    
    
    self.memoTV.placeholder = NSLocalizedString(@"请在此输入memo", nil);
    self.memoTV.lee_theme
    .LeeConfigTextColor(@"common_font_color_1");
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.memoTV.placeholderColor = HEX_RGB_Alpha(0x666666, 1);
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.memoTV.placeholderColor = HEXCOLOR(0xFFFFFF);
    }
}

@end
