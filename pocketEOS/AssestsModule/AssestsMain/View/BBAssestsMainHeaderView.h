//
//  BBAssestsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 15/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;
@interface BBAssestsMainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalAssestsVisibleBtn;
@property(nonatomic, copy) void(^changeAccountBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^transferBtnDidClickBlock)(void);
@property(nonatomic, copy) void(^recieveBtnDidClickBlock)(void);
@property(nonatomic, strong) Account *model;
@end
