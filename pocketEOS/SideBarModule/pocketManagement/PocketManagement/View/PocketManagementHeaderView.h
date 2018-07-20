//
//  PocketManagementHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

@protocol PocketManagementHeaderViewDelegate<NSObject>
- (void)createAccountBtnDidClick;
- (void)importAccountBtnDidClick;
- (void)changePasswordBtnDidClick;
- (void)backupWalletBtnDidClick;
@end


@interface PocketManagementHeaderView : BaseHeaderView

@property(nonatomic, weak) id<PocketManagementHeaderViewDelegate> delegate;

@end
