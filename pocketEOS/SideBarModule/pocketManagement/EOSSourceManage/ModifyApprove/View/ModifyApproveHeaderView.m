//
//  ModifyApproveView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ModifyApproveHeaderView.h"

@interface ModifyApproveHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end


@implementation ModifyApproveHeaderView

- (IBAction)modifyApproveSliderSlide:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyApproveSliderDidSlide:)]) {
        [self.delegate modifyApproveSliderDidSlide:sender];
    }
}

- (IBAction)confirmBtnClick:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmModifyBtnDidClick:)]) {
        [self.delegate confirmModifyBtnDidClick:sender];
    }
}


@end
