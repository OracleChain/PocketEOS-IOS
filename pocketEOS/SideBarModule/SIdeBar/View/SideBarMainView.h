//
//  SideBarMainView.h
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SideBarMainViewDelegate<NSObject>
- (void)QRCodeBtnDidClick:(UIButton *)sender;
- (void)avatarBtnDidClick:(UIButton *)sender;
- (void)managePocketBtnDidClick:(id)sender;
- (void)transactionRecordBtnDidClick:(UIButton *)sender;
- (void)candyBtnDidClick:(UIButton *)sender;
- (void)bp_voteBtnDidClick:(UIButton *)sender;
- (void)messagesCenterBtnDidClick:(UIButton *)sender;
- (void)systemSettingDidClick:(UIButton *)sender;

- (void)versionUpdateBtnDidClick:(UIButton *)sender;
- (void)dissmissSidebarBtnDidClick:(UIButton *)sender;
- (void)logoutBtnDidClick:(UIButton *)sender;
@end

@interface SideBarMainView : UIView
@property(nonatomic, weak) id<SideBarMainViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
