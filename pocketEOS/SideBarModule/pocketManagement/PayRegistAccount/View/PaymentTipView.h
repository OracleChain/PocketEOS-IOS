//
//  PaymentTipView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

@protocol PaymentTipViewDelegate<NSObject>


- (void)backgroundViewDidClick;
- (void)choosePaymentBtnDidClick:(UIButton *)sender;
- (void)confirmPayBtnDidClick:(UIButton *)sender;
@end


@interface PaymentTipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountChooseLabel;
@property(nonatomic, weak) id<PaymentTipViewDelegate> delegate;
@end
