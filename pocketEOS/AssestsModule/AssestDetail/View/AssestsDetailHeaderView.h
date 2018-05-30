//
//  AssestsDetailHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/7.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssestsDetailHeaderViewDelegate<NSObject>
- (void)transferBtnDidClick;
- (void)recieveBtnDidClick;
- (void)redPacketBtnDidClick;
@end

@class TendencyChartView;
@interface AssestsDetailHeaderView : BaseView
@property(nonatomic, weak) id<AssestsDetailHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet TendencyChartView *tendencyChartView;
@property (weak, nonatomic) IBOutlet UILabel *fluctuateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *Assest_balance_Label;
@property (weak, nonatomic) IBOutlet UILabel *assest_value_label;

@end
