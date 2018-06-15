//
//  BPVoteAmountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@protocol BPVoteAmountHeaderViewDelegate<NSObject>
- (void)sliderDidSlide:(UISlider *)sender;
- (void)explainBtnDidClick:(UIButton *)sender;
@end

@interface BPVoteAmountHeaderView : UIView

@property(nonatomic , strong) Account *model;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *stakedEOSLabel;

@property(nonatomic, weak) id<BPVoteAmountHeaderViewDelegate> delegate;

@end
