//
//  VersionUpdateHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "VersionUpdateHeaderView.h"

@interface VersionUpdateHeaderView()
@property (weak, nonatomic) IBOutlet UIView *versionIntoBaseView;
@property (weak, nonatomic) IBOutlet UIView *midLineView;

@property (weak, nonatomic) IBOutlet UIView *checkVersionBaseView;

@end


@implementation VersionUpdateHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    self.versionIntoBaseView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xFFFFFF))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x282A34));
    
    self.midLineView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    self.checkVersionBaseView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xFFFFFF))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x282A34));
}
- (IBAction)versionIntroduce:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(versionIntroduceBtnDidClick:)]) {
        [self.delegate versionIntroduceBtnDidClick:sender];
    }
}
- (IBAction)checkNewVersion:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkNewVersionBtnDidClick:)]) {
        [self.delegate checkNewVersionBtnDidClick:sender];
    }
}


@end
