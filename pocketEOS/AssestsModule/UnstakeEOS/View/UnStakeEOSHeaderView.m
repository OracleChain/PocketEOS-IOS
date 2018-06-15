//
//  UnStakeEOSHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/15.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "UnStakeEOSHeaderView.h"

@interface UnStakeEOSHeaderView()
@property (weak, nonatomic) IBOutlet UIView *baseView1;
@property (weak, nonatomic) IBOutlet UIView *baseView2;
@property (weak, nonatomic) IBOutlet UILabel *cpuAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *netAmountLabel;

@end


@implementation UnStakeEOSHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.baseView1.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF0F3F5 ))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x141414));
    
    self.baseView2.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF0F3F5 ))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x141414));
    
    
    
}

- (IBAction)cpuSlider:(UISlider *)sender {
    sender.value = sender.maximumValue;
}

- (IBAction)netSlider:(UISlider *)sender {
    sender.value = sender.maximumValue;
}

- (IBAction)confirmBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmUnStakeBtnDidClick)]) {
        [self.delegate confirmUnStakeBtnDidClick];
    }
}

-(void)setModel:(AccountResult *)model{
    if (model.data.eos_cpu_weight.doubleValue > 1) {
        self.cpuAmountLabel.text = [NSString stringWithFormat:@"%@ EOS/ %@ EOS", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_cpu_weight.doubleValue-1 ]], [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_cpu_weight.doubleValue ]]];
    }else{
        self.cpuAmountLabel.text = [NSString stringWithFormat:@"0 EOS" ];
    }
    
    if (model.data.eos_net_weight.doubleValue > 1) {
        self.netAmountLabel.text = [NSString stringWithFormat:@"%@ EOS/ %@ EOS", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_net_weight.doubleValue-1 ]], [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_net_weight.doubleValue ]]];
        
    }else{
        self.netAmountLabel.text = [NSString stringWithFormat:@"0 EOS"];
    }
    
}

@end
