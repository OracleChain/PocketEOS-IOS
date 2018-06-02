//
//  SegmentControlView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SegmentControlView.h"
#import "LineView.h"

@interface SegmentControlView()
// 选项的 背景
@property(nonatomic, strong) UIView *segmentControlbackgroundView;

/**
 底部的线
 */
@property(nonatomic, strong) UIView *bottomLineView;

@property(nonatomic, strong) NSMutableArray *buttonsArr;
@property(nonatomic, strong) NSMutableArray *lineViewsArr;

@end


@implementation SegmentControlView

- (NSMutableArray *)buttonsArr{
    if (!_buttonsArr) {
        _buttonsArr = [[NSMutableArray alloc] init];
    }
    return _buttonsArr;
}
- (NSMutableArray *)lineViewsArr{
    if (!_lineViewsArr) {
        _lineViewsArr = [[NSMutableArray alloc] init];
    }
    return _lineViewsArr;
}
- (UIView *)segmentControlbackgroundView{
    if (!_segmentControlbackgroundView) {
        _segmentControlbackgroundView = [[UIView alloc] init];
    }
    return _segmentControlbackgroundView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor =HEXCOLOR(0xF5F5F5);
    }
    return _bottomLineView;
}



- (void)updateViewWithArray:(NSMutableArray *)arr{
    
    [self addSubview:self.segmentControlbackgroundView];
    self.segmentControlbackgroundView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(44);
    
    [self addSubview:self.bottomLineView];
    self.bottomLineView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControlbackgroundView, 0).heightIs(10);
    
    for (int i = 0 ; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
        [btn setTitleColor:HEXCOLOR(0x4D7BFE) forState:(UIControlStateSelected)];
        [btn.titleLabel setFont: [UIFont systemFontOfSize:15]];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(segmentBtnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.segmentControlbackgroundView addSubview:btn];
        
        LineView *lineView = [[LineView alloc] init];
        lineView.tag = 1000 + i;
        [self.segmentControlbackgroundView addSubview: lineView];
        lineView.sd_layout.topSpaceToView(btn, 5).centerXEqualToView(btn).widthIs(80).heightIs(2);
        
        if (i == 0) {
            btn.sd_layout.centerYEqualToView(_segmentControlbackgroundView).centerXIs(SCREEN_WIDTH / 2 - 60 ).widthIs(80).heightIs(21);
            btn.selected = YES;
            lineView.backgroundColor = HEXCOLOR(0x4D7BFE);
        }else if (i == 1){
            btn.sd_layout.centerYEqualToView(_segmentControlbackgroundView).centerXIs(SCREEN_WIDTH / 2 + 60 ).widthIs(80).heightIs(21);
        }
        [self.buttonsArr addObject:btn];
        [self.lineViewsArr addObject:lineView];
    }
}

- (void)segmentBtnDidClick:(UIButton * )sender{
    
    NSLog(@"%ld", sender.tag);
    for (UIButton *btn in self.buttonsArr) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    for (LineView *lineView in self.lineViewsArr) {
        if (lineView.tag == sender.tag) {
            lineView.backgroundColor = HEXCOLOR(0x4D7BFE);
        }else{
            lineView.backgroundColor = HEXCOLOR(0xFFFFFF);
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControlBtnDidClick:)]) {
        [self.delegate segmentControlBtnDidClick:sender];
    }
    
}
@end
