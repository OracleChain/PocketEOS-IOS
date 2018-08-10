//
//  AccountManagementHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@protocol AccountManagementHeaderViewDelegate<NSObject>

- (void)ownerTipLabelDidTap;

@end


@interface AccountManagementHeaderView : BaseView

@property(nonatomic, weak) id<AccountManagementHeaderViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet BaseLabel *ownerPublicKeyLabel;

@property (weak, nonatomic) IBOutlet BaseLabel *activePublicKeyLabel;

@property(nonatomic , strong) AccountInfo *localAccount;

- (void)updateViewWithRemoteAccountInfo:(AccountInfo *)remoteAccount;
@end
