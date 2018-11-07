//
//  CpuNetManageHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CpuNetManageHeaderView.h"

@interface CpuNetManageHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *changeActionBaseView;

@property (weak, nonatomic) IBOutlet BaseConfirmButton *confirmBtn;
@property(nonatomic , strong) UILabel *leftLabel;
@property(nonatomic , strong) UILabel *rightLabel;
@end

@implementation CpuNetManageHeaderView

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = NSLocalizedString(@"抵押资源", nil);
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
        _rightLabel.text = NSLocalizedString(@"赎回资源", nil);
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
        self.cpuNetManageHeaderViewCurrentAction = CpuNetManageHeaderViewCurrentActionApprove;
        
        _leftLabel.backgroundColor = HEXCOLOR(0x4D7BFE);
        _leftLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        _rightLabel.backgroundColor = HEXCOLOR(0xF2F2F2);
        _rightLabel.textColor = HEXCOLOR(0x999999);
        
        self.cpuAmountInputTF.placeholder = NSLocalizedString(@"输入EOS数量", nil);
        self.netAmountInputTF.placeholder = NSLocalizedString(@"输入EOS数量", nil);
        self.cpuAmountUnitLabel.text = SymbolName_EOS;
        self.netAmountUnitLabel.text = SymbolName_EOS;
        [self.confirmBtn setTitle:NSLocalizedString(@"确认抵押", nil) forState:(UIControlStateNormal)];
        self.avalibleEOSAmountLabel.hidden = NO;
    }else if (sender.view.tag == 1001){
        self.cpuNetManageHeaderViewCurrentAction = CpuNetManageHeaderViewCurrentActionUnstake;
        
        
        _leftLabel.backgroundColor = HEXCOLOR(0xF2F2F2);
        _leftLabel.textColor = HEXCOLOR(0x999999);
        
        _rightLabel.backgroundColor = HEXCOLOR(0x4D7BFE);
        _rightLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        self.cpuAmountInputTF.placeholder = [NSString stringWithFormat:@"%@%@",  NSLocalizedString(@"可赎回", nil), self.model.data.self_delegated_bandwidth_cpu];
        self.netAmountInputTF.placeholder = [NSString stringWithFormat:@"%@%@",  NSLocalizedString(@"可赎回", nil), self.model.data.self_delegated_bandwidth_net];
        self.cpuAmountUnitLabel.text = @"";
        self.netAmountUnitLabel.text = @"";
        [self.confirmBtn setTitle:NSLocalizedString(@"确认赎回", nil) forState:(UIControlStateNormal)];
        self.avalibleEOSAmountLabel.hidden = YES;
    }
}

- (IBAction)confirmStakeBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cpuNetManageHeaderViewConfirmStakeBtnDidClick)]) {
        [self.delegate cpuNetManageHeaderViewConfirmStakeBtnDidClick];
    }
}



- (void)updateViewWithEOSResourceResult:(EOSResourceResult *)model{
    self.model = model;
    NSArray *totalCpuArr = [model.data.cpu_weight componentsSeparatedByString:@" "];
    NSArray *totalNetArr = [model.data.net_weight componentsSeparatedByString:@" "];
    NSString *totalCpuStr;
    NSString *totalNetStr;
    if (totalCpuArr.count>0 && totalNetArr.count > 0) {
        totalCpuStr = totalCpuArr[0];
        totalNetStr = totalNetArr[0];
//        self.totalStakeLabel.text = [NSString stringWithFormat:@"%.4f", totalCpuStr.doubleValue + totalNetStr.doubleValue];
//        self.cpuStakeLabel.text = [NSString stringWithFormat:@"%.4f", totalCpuStr.doubleValue];
//        self.netStakeLabel.text = [NSString stringWithFormat:@"%.4f", totalNetStr.doubleValue];
    }
    
    NSArray *selfCpuArr = [model.data.self_delegated_bandwidth_cpu componentsSeparatedByString:@" "];
    NSArray *selfNetArr = [model.data.self_delegated_bandwidth_net componentsSeparatedByString:@" "];
    NSString *selfCpuStr;
    NSString *selfNetStr;
    if (model.data.self_delegated_bandwidth) {
        if (selfCpuArr.count>0 && selfNetArr.count > 0  ) {
            selfCpuStr = selfCpuArr[0];
            selfNetStr = selfNetArr[0];
//            self.selfStakeLabel.text = [NSString stringWithFormat:@"%.4f", selfCpuStr.doubleValue + selfNetStr.doubleValue];
//            self.brrowStakeLabel.text = [NSString stringWithFormat:@"%.4f", (totalCpuStr.doubleValue + totalNetStr.doubleValue) - (selfCpuStr.doubleValue + selfNetStr.doubleValue)];
        }
    }else{
//        self.selfStakeLabel.text = [NSString stringWithFormat:@"0.0000 "];
//        self.brrowStakeLabel.text = [NSString stringWithFormat:@"%.4f", totalCpuStr.doubleValue + totalNetStr.doubleValue];
    }
    
    self.totalStakeLabel.text = [NSString stringWithFormat:@"%.4f", selfCpuStr.doubleValue + selfNetStr.doubleValue];
    self.cpuStakeLabel.text = [NSString stringWithFormat:@"%.4f", selfCpuStr.doubleValue];
    self.netStakeLabel.text = [NSString stringWithFormat:@"%.4f", selfNetStr.doubleValue];
    
    
    self.cpuDetailLabel.text = [NSString stringWithFormat:@"%.3fms/%.3fms" ,model.data.cpu_used.doubleValue/1000, model.data.cpu_max.doubleValue/1000];
    self.cpuProgressView.progress = model.data.cpu_used.doubleValue / model.data.cpu_max.doubleValue;
    if (self.cpuProgressView.progress > 0.9) {
        self.cpuProgressView.progressTintColor = HEXCOLOR(0xF05F5F);
    }
    
    self.cpuBorrowLabel.text = [NSString stringWithFormat:@"%@ %.4f %@",  NSLocalizedString(@"借用", nil), totalCpuStr.doubleValue - selfCpuStr.doubleValue, SymbolName_EOS];
    
    self.netDetailLabel.text = [NSString stringWithFormat:@"%.3f KB/%.3f KB" ,model.data.net_used.doubleValue / 1024, model.data.net_max.doubleValue / 1024];
    self.netProgressView.progress = model.data.net_used.doubleValue / model.data.net_max.doubleValue;
    if (self.netProgressView.progress > 0.9) {
        self.netProgressView.progressTintColor = HEXCOLOR(0xF05F5F);
    }
    self.netBorrowLabel.text = [NSString stringWithFormat:@"%@ %.4f %@",  NSLocalizedString(@"借用", nil), totalNetStr.doubleValue - selfNetStr.doubleValue, SymbolName_EOS];
    
    if (model.data.refund_request) {
        
        NSDate *refund_request_date = [NSDate dateFromString:model.data.refund_request_time];
        NSDate *nowDate = [NSDate getNowDateFromatAnDate:refund_request_date];
        
        NSDate *date = [NSDate date];
        NSTimeInterval interval = [date timeIntervalSinceDate:nowDate];
        
        int threeDayHour = 3 * 24;
        int pastHour = (int) interval / 60 / 60;
        int residueTotalHour = threeDayHour - pastHour;
        
        int residueDay = residueTotalHour / 24;
        int residueHour = residueTotalHour % 24;
        
        self.unstakeTimelabel.text = [NSString stringWithFormat:@"%dd %dh", residueDay, residueHour];

        NSLog(@"%d", residueTotalHour);
        
        self.unstakeAmountLabel.text = [NSString stringWithFormat:@"%.4f EOS", model.data.refund_request_cpu_amount.doubleValue  +  model.data.refund_request_net_amount.doubleValue];
    }else{
        self.unstakeTimelabel.text = @"--/--";
        self.unstakeAmountLabel.text = [NSString stringWithFormat:@"0.0000 %@", SymbolName_EOS];
    }
    
    
    self.avalibleEOSAmountLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"可用", nil), model.data.core_liquid_balance];
    
    
}

@end
