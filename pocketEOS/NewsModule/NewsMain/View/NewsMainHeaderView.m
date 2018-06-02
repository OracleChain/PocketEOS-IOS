//
//  NewsMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "NewsMainHeaderView.h"


@interface NewsMainHeaderView()
@property(nonatomic , strong) BaseSlimLineView *bottomLineView;
@end


@implementation NewsMainHeaderView

- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.4) delegate:nil placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _scrollView;
}

- (UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"downImg"];
        _arrowImg.userInteractionEnabled = YES;
    }
    return _arrowImg;
}

- (BaseLabel *)currentAssestsLabel{
    if (!_currentAssestsLabel) {
        _currentAssestsLabel = [[BaseLabel alloc] init];
        _currentAssestsLabel.text = @"按资产筛选";
        _currentAssestsLabel.font = [UIFont systemFontOfSize:13];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCurrentAssestsLabel:)];
        [_currentAssestsLabel addGestureRecognizer:tap];
        _currentAssestsLabel.userInteractionEnabled = YES;
        
    }
    return _currentAssestsLabel;
}
- (BaseSlimLineView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[BaseSlimLineView alloc] init];
        
    }
    return _bottomLineView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.currentAssestsLabel];
        self.currentAssestsLabel.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(_scrollView, 13.5).widthIs(80).heightIs(21);
        
        [self addSubview:self.arrowImg];
        self.arrowImg.sd_layout.leftSpaceToView(self.currentAssestsLabel, 0).centerYEqualToView(_currentAssestsLabel).widthIs(8.7).heightIs(5);
        
        [self addSubview:self.bottomLineView];
        self.bottomLineView.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
    }
    return self;
}

- (void)tapCurrentAssestsLabel:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentAssestsLabelDidTap:)]) {
        [self.delegate currentAssestsLabelDidTap:sender];
    }
}

@end
