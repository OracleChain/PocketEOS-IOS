//
//  CpuNetManageHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

typedef NS_ENUM(NSInteger, CpuNetManageHeaderViewCurrentAction) {
    CpuNetManageHeaderViewCurrentActionApprove ,         // Approve
    CpuNetManageHeaderViewCurrentActionUnstake,        // Unstake
} ;


#import "BaseView.h"
#import "EOSResourceResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CpuNetManageHeaderViewDelegate<NSObject>
- (void)cpuNetManageHeaderViewConfirmStakeBtnDidClick;
@end


@interface CpuNetManageHeaderView : BaseView
@property(nonatomic , assign) CpuNetManageHeaderViewCurrentAction cpuNetManageHeaderViewCurrentAction;


@property (weak, nonatomic) IBOutlet BaseLabel *totalStakeLabel;
@property (weak, nonatomic) IBOutlet BaseLabel *cpuStakeLabel;
@property (weak, nonatomic) IBOutlet BaseLabel *netStakeLabel;



@property (weak, nonatomic) IBOutlet BaseLabel1 *cpuBorrowLabel;

@property (weak, nonatomic) IBOutlet BaseLabel1 *cpuDetailLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *cpuProgressView;
@property (weak, nonatomic) IBOutlet BaseLabel1 *netDetailLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *netProgressView;
@property (weak, nonatomic) IBOutlet BaseLabel1 *netBorrowLabel;


@property (weak, nonatomic) IBOutlet UILabel *unstakeTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *unstakeAmountLabel;



@property (weak, nonatomic) IBOutlet UITextField *cpuAmountInputTF;
@property (weak, nonatomic) IBOutlet UITextField *netAmountInputTF;
@property (weak, nonatomic) IBOutlet UILabel *cpuAmountUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *netAmountUnitLabel;


@property (weak, nonatomic) IBOutlet BaseLabel1 *avalibleEOSAmountLabel;



@property(nonatomic, weak) id<CpuNetManageHeaderViewDelegate> delegate;


- (void)updateViewWithEOSResourceResult:(EOSResourceResult *)model;


@property(nonatomic , strong) EOSResourceResult *model;
@end

NS_ASSUME_NONNULL_END
