//
//  BPVoteHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteHeaderView.h"
#import "Account.h"

@interface BPVoteHeaderView()


@end


@implementation BPVoteHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];

}

- (IBAction)changeAccountBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAccountBtnDidClick:)]) {
        [self.delegate changeAccountBtnDidClick:sender];
    }
}



-(void)setModel:(AccountResult *)model{
    self.accountNameLabel.text = model.data.account_name;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ : %@EOS", NSLocalizedString(@"余额", nil), [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_balance.doubleValue ]]];
    self.balanceOfVotedLabel.text = [NSString stringWithFormat:@"%@ EOS", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.data.eos_cpu_weight.doubleValue + model.data.eos_net_weight.doubleValue]]];
}



@end
