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
}

@end
