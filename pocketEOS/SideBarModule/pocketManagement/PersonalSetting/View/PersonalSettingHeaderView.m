//
//  PersonalSettingHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PersonalSettingHeaderView.h"

@interface PersonalSettingHeaderView()


@end


@implementation PersonalSettingHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.line2.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    self.line4.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    
}

- (IBAction)avatarBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarBtnDidClick:)]) {
        [self.delegate avatarBtnDidClick:sender];
    }
    
}

- (IBAction)nameBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nameBtnDidClick:)]) {
        [self.delegate nameBtnDidClick:sender];
    }
    
}

- (IBAction)wechatIDBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wechatIDBtnDidClick:)]) {
        [self.delegate wechatIDBtnDidClick:sender];
    }
}

- (IBAction)qqIDBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(qqIDBtnBtnDidClick:)]) {
        [self.delegate qqIDBtnBtnDidClick:sender];
    }
    
}

@end
