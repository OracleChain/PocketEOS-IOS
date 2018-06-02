//
//  RedPacketHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RedPacketHeaderView.h"
#import "UITextView+Placeholder.h"


@implementation RedPacketHeaderView


- (IBAction)selectAccount:(UIButton *)sender {
    [sender setSelected: !sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAccountBtnDidClick:)]) {
        [self.delegate selectAccountBtnDidClick: sender];
    }
}

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
    self.descriptionTextView.placeholder = @"恭喜发财, 大吉大利";
     self.tipLabel.font = [UIFont boldSystemFontOfSize:24];
    self.descriptionTextView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF8F8F8))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1))
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.6));
}

@end
