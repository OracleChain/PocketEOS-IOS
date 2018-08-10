//
//  PayRegistAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PayRegistAccountHeaderView.h"

@interface PayRegistAccountHeaderView()
@property (weak, nonatomic) IBOutlet BaseLabel1 *cpuDetailLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *netDetailLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *ramDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *memoBaseView;
@end



@implementation PayRegistAccountHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.memoBaseView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF8F8F8))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
}

- (IBAction)confirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createBtnDidClick:)]) {
        [self.delegate createBtnDidClick:sender];
    }
}

- (IBAction)privateKeyBeSameModeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(privateKeyBeSameModeBtnDidClick:)]) {
        [self.delegate privateKeyBeSameModeBtnDidClick:sender];
    }
}

- (IBAction)privateKeyBeDiffrentModeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(privateKeyBeDiffrentModeBtnDidClick:)]) {
        [self.delegate privateKeyBeDiffrentModeBtnDidClick:sender];
    }
}


- (void)updateViewWithResourceModel:(CreateAccountResourceRespModel *)model{
    self.payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f%@",model.cnyCost.floatValue / 100, NSLocalizedString(@"元", nil)];
    self.cpuDetailLabel.text = model.cpu;
    self.netDetailLabel.text = model.net;
    self.ramDetailLabel.text = model.ram;
    
}

@end
