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
//    if ([[LEETheme currentThemeTag] isEqualToString:SOCIAL_MODE]) {
//        
//    }else if([[LEETheme currentThemeTag] isEqualToString:BLACKBOX_MODE]){
//        self.avatarBaseView.hidden = YES;
//        self.wechatBaseView.hidden = YES;
//        self.qqBaseView.hidden = YES;
//        self.nameBaseView.sd_layout.topSpaceToView(self, 0);
//        
//        
//    }
    
    
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
