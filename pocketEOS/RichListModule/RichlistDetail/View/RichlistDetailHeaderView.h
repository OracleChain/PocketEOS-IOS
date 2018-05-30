//
//  RichlistDetailHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Account;
@interface RichlistDetailHeaderView : BaseView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;
@property(nonatomic, copy) void(^changeAccountBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^transferBtnDidClickBlock)(void);
@property(nonatomic, strong) Account *model;


@end
