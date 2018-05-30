//
//  AssestsDetailHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/7.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AssestsDetailHeaderView.h"
#import "TendencyChartView.h"

@interface AssestsDetailHeaderView()
@property (weak, nonatomic) IBOutlet TendencyChartView *chartView;


@end


@implementation AssestsDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.chartView.frame = CGRectMake(20, 98, SCREEN_WIDTH - MARGIN_20 * 2, 55);
    
}

- (IBAction)transferBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(transferBtnDidClick)]) {
        [self.delegate transferBtnDidClick];
    }
    
    
}

- (IBAction)recieveBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recieveBtnDidClick)]) {
        [self.delegate recieveBtnDidClick];
    }
}

- (IBAction)redPacketBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(redPacketBtnDidClick)]) {
        [self.delegate redPacketBtnDidClick];
    }
}

@end
