//
//  TradeRamHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "AccountResult.h"
#import "Account.h"

@protocol TradeRamHeaderViewDelegate<NSObject>
- (void)confirmTradeRamBtnDidClick;
- (void)modifySliderDidSlide:(UISlider *)sender;
@end


@interface TradeRamHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UISlider *modifyRamSlider;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@property(nonatomic , strong) AccountResult *accountResult;
@property (weak, nonatomic) IBOutlet BaseLabel *titleLabel;
@property(nonatomic, weak) id<TradeRamHeaderViewDelegate> delegate;

@end
