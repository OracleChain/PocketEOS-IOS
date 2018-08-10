//
//  PocketManagementHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PocketManagementHeaderView.h"

@interface PocketManagementHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *createAccountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backupImageView;
@property (weak, nonatomic) IBOutlet UIImageView *changePasswordImageView;
@property (weak, nonatomic) IBOutlet UIImageView *importAccountImageView;

@end


@implementation PocketManagementHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.createAccountImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"createAccount"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"createAccount_BB"]);
    
    self.backupImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"backup"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"backup_BB"]);
    
    self.changePasswordImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"changePassword"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"changePassword_BB"]);
    
    self.importAccountImageView.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"importAccount"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"importAccount_BB"]);
    
}

- (IBAction)createAccountBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createAccountBtnDidClick)]) {
        [self.delegate createAccountBtnDidClick];
    }
}

- (IBAction)personalCenterBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personalCenterBtnDidClick)]) {
        [self.delegate personalCenterBtnDidClick];
    }
}

- (IBAction)changePasswordBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePasswordBtnDidClick)]) {
        [self.delegate changePasswordBtnDidClick];
    }
}

- (IBAction)backupWalletBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backupWalletBtnDidClick)]) {
        [self.delegate backupWalletBtnDidClick];
    }
    
}

@end
