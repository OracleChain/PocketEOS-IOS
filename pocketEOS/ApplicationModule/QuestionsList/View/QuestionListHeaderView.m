//
//  QuestionListHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "QuestionListHeaderView.h"
#import "SegmentControlView.h"

@interface QuestionListHeaderView()
// 返回
@property(nonatomic, strong) UIButton *backBtn;
// 背景图
@property(nonatomic, strong) UIImageView *backgroundImg;

@end


@implementation QuestionListHeaderView


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [_backBtn setImage:[UIImage imageNamed:@"back_white"] forState:(UIControlStateNormal)];
        
    }
    return _backBtn;
}

- (UIImageView *)backgroundImg{
    if (!_backgroundImg) {
        _backgroundImg = [[UIImageView alloc] init];
        _backgroundImg.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"paid_answer"]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"paid_answer_BB"]);
        _backgroundImg.userInteractionEnabled = YES;
    }
    return _backgroundImg;
}

- (SegmentControlView *)segmentControlView{
    if (!_segmentControlView) {
        _segmentControlView = [[SegmentControlView alloc] init];
    }
    return _segmentControlView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.backgroundImg];
        self.backgroundImg.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).heightIs(SCREEN_WIDTH * 200 / 375);
        
        [self.backgroundImg addSubview:self.backBtn];
        self.backBtn.sd_layout.leftSpaceToView(self.backgroundImg, 6 ).topSpaceToView(self.backgroundImg, 34).widthIs(30).heightIs(30);
        
        [self addSubview:self.segmentControlView];
        self.segmentControlView.frame = CGRectMake(0, SCREEN_WIDTH * 200 / 375, SCREEN_WIDTH, 54);
        
    }
    return self;
}

- (void)updateViewWithArray:(NSMutableArray *)arr{
    [self.segmentControlView updateViewWithArray:arr];
}

// 展示 BackgroundImg
- (void)showBackgroundImg{
    WS(weakSelf);
    [self sd_clearAutoLayoutSettings]; weakSelf.backgroundImg.sd_layout.leftEqualToView(weakSelf).rightEqualToView(weakSelf).topEqualToView(weakSelf).heightIs(SCREEN_WIDTH * 200 / 375);
    weakSelf.backBtn.sd_layout.leftSpaceToView(weakSelf.backgroundImg, 6 ).topSpaceToView(weakSelf.backgroundImg, 28).widthIs(30).heightIs(30);
    weakSelf.segmentControlView.frame = CGRectMake(0, SCREEN_WIDTH * 200 / 375, SCREEN_WIDTH, 54);
    
    [self setNeedsLayout];
}

// 隐藏 BackgroundImg
- (void)hideBackgroundImg{
    WS(weakSelf);
    [self sd_clearAutoLayoutSettings];
    weakSelf.segmentControlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
    weakSelf.backgroundImg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [self setNeedsLayout];
}

- (void)backBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnDidClick:)]) {
        [self.delegate backBtnDidClick:sender];
    }
}


@end
