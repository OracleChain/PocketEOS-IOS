//
//  BPVoteAmountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteAmountHeaderView.h"



@interface BPVoteAmountHeaderView()
@property(nonatomic , strong) UILabel *eosLabel;
@property(nonatomic , strong) UIButton *editBtn;
@end



@implementation BPVoteAmountHeaderView

- (UILabel *)eosLabel{
    if (!_eosLabel) {
        _eosLabel = [[UILabel alloc] init];
        _eosLabel.text = @"EOS";
        _eosLabel.textColor = HEXCOLOR(0xFFFFFF);
        _eosLabel.font = [UIFont systemFontOfSize:14];
    }
    return _eosLabel;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setImage:[UIImage imageNamed:@"edit_blue"] forState:(UIControlStateNormal)];
        [_editBtn addTarget:self action:@selector(editAmountBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editBtn;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.amountTF.backgroundColor = RGB(20, 20, 20);
    self.amountTF.textColor = HEXCOLOR(0xFFFFFF);
    [self addSubview:self.eosLabel];
    self.eosLabel.sd_layout.leftSpaceToView(self.amountTF, 2).centerYEqualToView(self.amountTF).widthIs(30).heightIs(14);
    
//    [self addSubview:self.editBtn];
//    self.editBtn.sd_layout.leftSpaceToView(self.eosLabel, 8).centerYEqualToView(self.amountTF).widthIs(13).heightEqualToWidth();
    
}

- (IBAction)amountSlider:(UISlider *)sender {
//    [TOASTVIEW showWithText:@"主网启动后, 方可设置投票数量!"];
//    sender.value = sender.maximumValue;
    
//    [self.eosLabel sd_clearAutoLayoutSettings];
//    self.eosLabel.sd_layout.leftSpaceToView(self.amountTF, 2).centerYEqualToView(self.amountTF).widthIs(30).heightIs(14);
//
//    [self.editBtn sd_clearAutoLayoutSettings];
//    self.editBtn.sd_layout.leftSpaceToView(self.eosLabel, 8).centerYEqualToView(self.amountTF).widthIs(13).heightEqualToWidth();
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderDidSlide:)]) {
        [self.delegate sliderDidSlide:sender];
    }
}


- (void)editAmountBtn:(UIButton *)sender {
    [self.amountTF becomeFirstResponder];
}

- (IBAction)explainLockBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(explainBtnDidClick:)]) {
        [self.delegate explainBtnDidClick:sender];
    }
}



- (void)setModel:(Account *)model{
    self.amountSlider.minimumValue = 0;
    self.amountSlider.maximumValue = model.eos_balance.doubleValue ;
    self.amountSlider.value = 0;
    self.amountTF.text = [NSString stringWithFormat:@"%@",[NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue ]]];
    
    self.eosLabel.sd_layout.leftSpaceToView(self.amountTF, 2).centerYEqualToView(self.amountTF).widthIs(30).heightIs(14);
    self.stakedEOSLabel.text = [NSString stringWithFormat:@"%@ EOS", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_cpu_weight.doubleValue + model.eos_net_weight.doubleValue ]]];
//    self.editBtn.sd_layout.leftSpaceToView(self.eosLabel, 8).centerYEqualToView(self.amountTF).widthIs(13).heightEqualToWidth();
}
@end
