//
//  AssestsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;
@interface AssestsMainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;

@property (weak, nonatomic) IBOutlet UIButton *totalAssestsVisibleBtn;

@property(nonatomic, copy) void(^changeAccountBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^transferBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^recieveBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^redPacketBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^accountQRCodeImgDidTapBlock)(void);
@property(nonatomic, copy) void(^avatarImgDidTapBlock)(void);
@property(nonatomic, strong) Account *model;
@end
