//
//  RamManageHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RamManageHeaderView.h"

@interface RamManageHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *changeActionBaseView;

@property(nonatomic , strong) UILabel *leftLabel;
@property(nonatomic , strong) UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet BaseConfirmButton *confirmBtn;
@property (weak, nonatomic) IBOutlet BaseLabel *ramAmountBaseItemNameLabel;

@end

@implementation RamManageHeaderView

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = NSLocalizedString(@"买入内存", nil);
        _leftLabel.backgroundColor = HEXCOLOR(0x4D7BFE);
        _leftLabel.textColor = HEXCOLOR(0xFFFFFF);
        _leftLabel.sd_cornerRadius = @15;
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.tag = 1000;
        
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = NSLocalizedString(@"卖出内存", nil);
        _rightLabel.backgroundColor = HEXCOLOR(0xF2F2F2);
        _rightLabel.textColor = HEXCOLOR(0x999999);
        _rightLabel.sd_cornerRadius = @15;
        _rightLabel.font = [UIFont systemFontOfSize:13];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.tag = 1001;
        
    }
    return _rightLabel;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.changeActionBaseView.sd_cornerRadius = @15;
    self.changeActionBaseView.backgroundColor = HEXCOLOR(0xF2F2F2);
    
    [self.changeActionBaseView addSubview:self.leftLabel];
    self.leftLabel.sd_layout.leftSpaceToView(self.changeActionBaseView, 2).topSpaceToView(self.changeActionBaseView, 2).bottomSpaceToView(self.changeActionBaseView, 2).widthIs(84);
    
    [self.changeActionBaseView addSubview:self.rightLabel];
    self.rightLabel.sd_layout.rightSpaceToView(self.changeActionBaseView, 2).topSpaceToView(self.changeActionBaseView, 2).bottomSpaceToView(self.changeActionBaseView, 2).widthIs(84);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeActionBaseViewLabelTap:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeActionBaseViewLabelTap:)];
    [self.leftLabel addGestureRecognizer:tap];
    [self.rightLabel addGestureRecognizer:tap1];
    self.leftLabel.userInteractionEnabled =YES;
    self.rightLabel.userInteractionEnabled =YES;
    self.changeActionBaseView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    
}


- (void)changeActionBaseViewLabelTap:(UITapGestureRecognizer *)sender{
    
    if (sender.view.tag == 1000) {
        
        
        _leftLabel.backgroundColor = HEXCOLOR(0x4D7BFE);
        _leftLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        _rightLabel.backgroundColor = HEXCOLOR(0xF2F2F2);
        _rightLabel.textColor = HEXCOLOR(0x999999);
        
        self.ramManageHeaderViewCurrentAction = RamManageHeaderViewCurrentActionBuyRam;
        self.eosAmountTF.placeholder = NSLocalizedString(@"输入EOS数量", nil);
        self.ramAmountUnitLabel.text = @"EOS";
        [self.confirmBtn setTitle:NSLocalizedString(@"确认买入", nil) forState:(UIControlStateNormal)];
        self.ramAmountBaseItemNameLabel.text = NSLocalizedString(@"买入数量", nil);
        self.avalibleAmountLabel.hidden = NO;
    }else if (sender.view.tag == 1001){
        
        _leftLabel.backgroundColor = HEXCOLOR(0xF2F2F2);
        _leftLabel.textColor = HEXCOLOR(0x999999);
        
        _rightLabel.backgroundColor = HEXCOLOR(0x4D7BFE);
        _rightLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        self.ramManageHeaderViewCurrentAction = RamManageHeaderViewCurrentActionSellRam;
        self.eosAmountTF.placeholder = NSLocalizedString(@"输入RAM数量", nil);
        self.ramAmountUnitLabel.text = @"KB";
        [self.confirmBtn setTitle:NSLocalizedString(@"确认卖出", nil) forState:(UIControlStateNormal)];
        self.ramAmountBaseItemNameLabel.text = NSLocalizedString(@"卖出数量", nil);
        self.avalibleAmountLabel.hidden = YES;
    }
    
    
}


- (IBAction)confirmStakeBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ramManageHeaderViewConfirmStakeBtnDidClick)]) {
        [self.delegate ramManageHeaderViewConfirmStakeBtnDidClick];
    }
}


- (void)updateViewWithEOSResourceResult:(EOSResourceResult *)model{
    CGFloat progress = model.data.ram_usage.doubleValue/model.data.ram_max.doubleValue;
    self.ramProgressView.progress = progress;
    if (progress > 0.9 ) {
        self.ramProgressView.progressTintColor = HEXCOLOR(0xF05F5F);
    }
    
    
    self.ramDetailLabel.text = [NSString stringWithFormat:@"%.3fKB/%.3fKB", model.data.ram_usage.doubleValue / 1024, model.data.ram_max.doubleValue/ 1024];
    
    
    
    
    self.avalibleAmountLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"可用", nil), model.data.core_liquid_balance];
}

@end
