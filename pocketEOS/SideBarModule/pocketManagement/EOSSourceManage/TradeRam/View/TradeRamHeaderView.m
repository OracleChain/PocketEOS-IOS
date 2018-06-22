//
//  TradeRamHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TradeRamHeaderView.h"

@interface TradeRamHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *predictLabel;

@end

@implementation TradeRamHeaderView

- (IBAction)modifyRamSliderSlide:(UISlider *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifySliderDidSlide:)]) {
        [self.delegate modifySliderDidSlide:sender];
    }
}

- (IBAction)confirmBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmTradeRamBtnDidClick)]) {
        [self.delegate confirmTradeRamBtnDidClick];
    }
}

-(void)setEosResourceResult:(EOSResourceResult *)eosResourceResult{
    
    self.predictLabel.text = @"预计配额：1000.00 ms";
}

-(void)setAccountResult:(AccountResult *)accountResult{
    self.amountLabel.text = [NSString stringWithFormat:@"%@ EOS", VALIDATE_STRING([NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:accountResult.data.eos_balance.doubleValue ]])];
}

@end
