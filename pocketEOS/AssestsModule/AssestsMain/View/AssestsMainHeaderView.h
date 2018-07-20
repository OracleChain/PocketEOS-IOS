//
//  AssestsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenInfo.h"

@class Account;
@interface AssestsMainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;

@property (weak, nonatomic) IBOutlet UIButton *totalAssestsVisibleBtn;

@property(nonatomic, copy) void(^changeAccountBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^transferBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^recieveBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^redPacketBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^ramTradeBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^accountBtnDidTapBlock)(void);
@property(nonatomic, copy) void(^avatarImgDidTapBlock)(void);
@property(nonatomic, copy) void(^addAssestsImgDidTapBlock)(void);
@property(nonatomic, strong) Account *model;

- (void)updateViewWithDataArray:(NSMutableArray<TokenInfo *> *)dataArray;
@property(nonatomic , strong) NSMutableArray *tokenInfoDataArray;
@end
