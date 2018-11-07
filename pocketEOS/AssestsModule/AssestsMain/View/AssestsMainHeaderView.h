//
//  AssestsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenInfo.h"
#import "EOSResourceResult.h"

@interface AssestsMainHeaderView : UIView
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

- (void)updateViewWithDataArray:(NSMutableArray<TokenInfo *> *)dataArray;

- (void)updateViewWithEOSResourceResult:(EOSResourceResult *)model;

@property(nonatomic , strong) NSMutableArray *tokenInfoDataArray;


@property (weak, nonatomic) IBOutlet UIView *assestHeaderButtonsBackgroundView;


@property (weak, nonatomic) IBOutlet UIImageView *shortageImageView;


@end
