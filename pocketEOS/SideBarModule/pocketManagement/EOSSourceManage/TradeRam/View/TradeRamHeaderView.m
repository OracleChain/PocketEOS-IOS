//
//  TradeRamHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TradeRamHeaderView.h"

@interface TradeRamHeaderView()
@property (weak, nonatomic) IBOutlet BaseView *baseTopView;


@end

@implementation TradeRamHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    self.baseTopView.lee_theme.LeeConfigBackgroundColor(@"baseTopView_background_color");
}

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

@end
