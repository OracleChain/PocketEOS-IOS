//
//  TradeRamHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

@protocol TradeRamHeaderViewDelegate<NSObject>
- (void)confirmTradeRamBtnDidClick;
- (void)modifySliderDidSlide:(UISlider *)sender;
@end


@interface TradeRamHeaderView : UIView
@property (weak, nonatomic) IBOutlet UISlider *modifyRamSlider;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *predictLabel;
@property (weak, nonatomic) IBOutlet BaseLabel *titleLabel;
@property(nonatomic, weak) id<TradeRamHeaderViewDelegate> delegate;


@end
