//
//  SideBarMainView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SideBarMainView.h"

@interface SideBarMainView()
@property (weak, nonatomic) IBOutlet UIImageView *candyEnergyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *candyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageCenterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *feedbackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *systemSettingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *versionUpdateImageView;

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet BaseLabel *walletManageLabel;
@property (weak, nonatomic) IBOutlet UIView *candyBaseView;
@property (weak, nonatomic) IBOutlet UIView *messageCenterBaseView;
@property (weak, nonatomic) IBOutlet UIView *feedbackBaseView;
@property (weak, nonatomic) IBOutlet UIView *systemSettingBaseView;
@property (weak, nonatomic) IBOutlet UIView *versionUpdateBaseView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end



@implementation SideBarMainView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.candyImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"candyIcon"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"candyIcon_BB"]);
    self.messageCenterImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"messageCenter"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"messageCenter_BB"]);
    
    self.feedbackImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"feedBack"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"feedBack_BB"]);
    
    self.systemSettingImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"systemSetting"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"systemSetting_BB"]);
    
    self.versionUpdateImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"versionUpdate"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"versionUpdate_BB"]);
    
    
    if ([[LEETheme currentThemeTag] isEqualToString:SOCIAL_MODE]) {
        self.candyBaseView.hidden = NO;
    }else if([[LEETheme currentThemeTag] isEqualToString:BLACKBOX_MODE]){
        self.candyBaseView.hidden = YES;
        self.avatarImg.hidden = YES;
        self.messageCenterBaseView.sd_layout.topSpaceToView(self.walletManageLabel, 59);
        self.feedbackBaseView.sd_layout.topSpaceToView(self.walletManageLabel, 59+(20+30)*1);
        self.systemSettingBaseView.sd_layout.topSpaceToView(self.walletManageLabel, 59+(20+30)*2);
        self.versionUpdateBaseView.sd_layout.topSpaceToView(self.walletManageLabel, 59+(20+30)*3);
        
    }
    
    self.logoutBtn.lee_theme
    .LeeConfigBackgroundColor(@"baseView_background_color")
    .LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x000000), UIControlStateNormal)
    .LeeAddButtonTitleColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF), UIControlStateNormal);
}

- (IBAction)QRCodeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeBtnDidClick:)]) {
        [self.delegate QRCodeBtnDidClick:sender];
    }
}

- (IBAction)avatarBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarBtnDidClick:)]) {
        [self.delegate avatarBtnDidClick:sender];
    }
}

- (IBAction)managePocketBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(managePocketBtnDidClick:)]) {
        [self.delegate managePocketBtnDidClick:sender];
    }
}

- (IBAction)transactionRecordBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(transactionRecordBtnDidClick:)]) {
        [self.delegate transactionRecordBtnDidClick:sender];
    }
}

- (IBAction)messagesCenterBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesCenterBtnDidClick:)]) {
        [self.delegate messagesCenterBtnDidClick:sender];
    }
}
- (IBAction)candyBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(candyBtnDidClick:)]) {
        [self.delegate candyBtnDidClick:sender];
    }
}


- (IBAction)feedBackBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedBackBtnDidClick:)]) {
        [self.delegate feedBackBtnDidClick:sender];
    }
}

- (IBAction)systemSetting:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemSettingDidClick:)]) {
        [self.delegate systemSettingDidClick:sender];
    }
}

- (IBAction)versionUpdateBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(versionUpdateBtnDidClick:)]) {
        [self.delegate versionUpdateBtnDidClick:sender];
    }
}

- (IBAction)dismissSideBar:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissSidebarBtnDidClick:)]) {
        [self.delegate dissmissSidebarBtnDidClick:sender];
    }
}

- (IBAction)logout:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(logoutBtnDidClick:)]) {
        [self.delegate logoutBtnDidClick:sender];
    }
}

@end
