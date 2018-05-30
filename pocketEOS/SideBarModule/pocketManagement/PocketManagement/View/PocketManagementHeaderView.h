//
//  PocketManagementHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PocketManagementHeaderViewDelegate<NSObject>
@optional
- (void)createAccountBtnDidClick:(UIButton *)sender;
- (void)importAccountBtnDidClick:(UIButton *)sender;
- (void)backupPocketBtnDidClick:(UIButton *)sender;
- (void)changePasswordBtnDidClick:(UIButton *)sender;
- (void)mainAccountBtnDidClick:(UIButton *)sender;

@end

@interface PocketManagementHeaderView : BaseView
@property(nonatomic, weak) id<PocketManagementHeaderViewDelegate> delegate;
@end
