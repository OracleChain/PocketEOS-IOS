//
//  ModifyApproveView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ModifyApproveHeaderView.h"

@interface ModifyApproveHeaderView()
@property (weak, nonatomic) IBOutlet UISlider *modifyApproveSlider;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *predictLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end


@implementation ModifyApproveHeaderView

- (IBAction)modifyApproveSliderSlide:(UISlider *)sender {
    NSLog(@"%f", sender.value);
}

- (IBAction)confirmBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmModifyBtnDidClick:)]) {
        [self.delegate confirmModifyBtnDidClick:sender];
    }
}

-(void)setModel:(EOSResourceResult *)model{
    
    self.amountLabel.text = @"300.00 EOS";
    self.predictLabel.text = @"预计配额：1000.00 ms";
    self.tipLabel.text = @"当前可提取 299.00 EOS";
}

@end
