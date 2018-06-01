//
//  CQMarqueeView.m
//  CQMarqueeView
//
//  Created by 蔡强 on 2017/8/22.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "CQMarqueeView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"

@implementation CQMarqueeView{
    UILabel *_marqueeLabel;
    /** 控制跑马灯的timer */
    CADisplayLink *_displayLink;
    
    NSInteger _count;
}

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI {
//    self.backgroundColor = [UIColor colorWithHexString:@"fff4d8"];
    self.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xFEFCEC))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x474747));
    self.clipsToBounds = YES;
    
    //------- 左边的喇叭 -------//
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 9+3, 16, 12)];
//    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"volume-marquee"];
    
    //------- 右边的关闭按钮 -------//
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 33, 0+3, 30, 30)];
//    [self addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"close-marquee"] forState:UIControlStateNormal];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //------- marquee View -------//
    
    // 背景
    UIView *marqueeBgView = [[UIView alloc] initWithFrame:CGRectMake(41, 0, self.width - 41 - 38, self.height)];
    [self addSubview:marqueeBgView];
    marqueeBgView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xFEFCEC ))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x474747 ));
    marqueeBgView.clipsToBounds = YES;
    
    // marquee label
    _marqueeLabel = [[UILabel alloc] initWithFrame:marqueeBgView.bounds];
    [marqueeBgView addSubview:_marqueeLabel];
//    _marqueeLabel.textColor = [UIColor colorWithHexString:@"ff6666"];
    _marqueeLabel.lee_theme.LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0xF76A24))
        .LeeAddTextColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF));
    _marqueeLabel.font = [UIFont systemFontOfSize:13];
}

#pragma mark - 关闭按钮点击
/** 关闭按钮点击 */
- (void)closeButtonClicked:(UIButton *)sender {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(marqueeView:closeButtonDidClick:)]) {
        [self.delegate marqueeView:self closeButtonDidClick:sender];
    }
}

#pragma mark - 赋值跑马灯文本数组
/** 赋值跑马灯文本数组 */
- (void)setMarqueeTextArray:(NSArray *)marqueeTextArray {
    _marqueeTextArray = marqueeTextArray;
    
    // 默认展示第一条
    [self setMarqueeText:_marqueeTextArray.firstObject];
    // 从最右边开始移动
    _marqueeLabel.x = _marqueeLabel.superview.width;
    
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _count = 0;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshMarqueeLabelFrame)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

/** 改变label位置 */
- (void)refreshMarqueeLabelFrame {
    _marqueeLabel.maxX -= 1;
    if (_marqueeLabel.maxX <= 0) { // 当前信息跑完
        _count ++;
        _marqueeLabel.x = self.width - 41 - 38; // 回到最右边
        [self setMarqueeText:_marqueeTextArray[_count % self.marqueeTextArray.count]];
    }
}

/** 赋值跑马灯文本 */
- (void)setMarqueeText:(NSString *)marqueeText {
    _marqueeLabel.text = marqueeText;
    [_marqueeLabel sizeToFit];
    _marqueeLabel.centerY = self.height / 2;
}

@end
