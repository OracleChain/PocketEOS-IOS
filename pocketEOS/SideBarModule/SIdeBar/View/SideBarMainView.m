//
//  SideBarMainView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SideBarMainView.h"

@interface SideBarMainView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
// top
@property (weak, nonatomic) IBOutlet UIButton *QRCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

// mid
@property (weak, nonatomic) IBOutlet UIView *candyBaseView;


@property (weak, nonatomic) IBOutlet UIView *voteBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;

// bottom
@property (weak, nonatomic) IBOutlet UIImageView *messageCenterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transactionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *systemSettingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *versionUpdateImageView;


@property (weak, nonatomic) IBOutlet UIView *messageCenterBaseView;
@property (weak, nonatomic) IBOutlet UIView *transactionRecordBaseView;
@property (weak, nonatomic) IBOutlet UIView *systemSettingBaseView;
@property (weak, nonatomic) IBOutlet UIView *versionUpdateBaseView;

@end



@implementation SideBarMainView


- (void)awakeFromNib{
    [super awakeFromNib];
    if ([DeviceType getIsIpad]) {
        self.scrollHeight.constant = 100;
    }
    
    
    self.voteImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"bpvote"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"bpvote_BB"]);
    self.messageCenterImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"messageCenter"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"messageCenter_BB"]);
    
        self.transactionImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"transactionrecord_icon"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"transaction_history_BB"]);
    self.systemSettingImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"systemSetting"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"systemSetting_BB"]);
    
    self.versionUpdateImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"versionUpdate"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"versionUpdate_BB"]);
    
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.QRCodeButton.hidden = NO;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.avatarImg.hidden = YES;
        self.QRCodeButton.hidden = YES;
        self.voteBaseView.sd_layout.leftEqualToView(self.candyBaseView).topEqualToView(self.candyBaseView).rightEqualToView(self.candyBaseView).bottomEqualToView(self.candyBaseView);

    }
    
    self.logoutBtn.lee_theme
    .LeeConfigBackgroundColor(@"baseView_background_color")
    .LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x000000), UIControlStateNormal)
    .LeeAddButtonTitleColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF), UIControlStateNormal);
    
    
//    self.walletManageImgView.lee_theme
//    .LeeConfigImage(@"pocketManageImage");
//
//    self.transactionImageView.lee_theme
//    .LeeConfigImage(@"transaction_historyImage");
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

- (IBAction)candyBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(candyBtnDidClick:)]) {
        [self.delegate candyBtnDidClick:sender];
    }
}

- (IBAction)bp_voteBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bp_voteBtnDidClick:)]) {
        [self.delegate bp_voteBtnDidClick:sender];
    }
}

- (IBAction)messagesCenterBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesCenterBtnDidClick:)]) {
        [self.delegate messagesCenterBtnDidClick:sender];
    }
}

- (IBAction)transactionRecordBtn:(UIButton *)sender {
    [MobClick event:@"侧边栏_交易记录"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(transactionRecordBtnDidClick:)]) {
        [self.delegate transactionRecordBtnDidClick:sender];
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
