//
//  BPVoteFooterView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteFooterView.h"

@interface BPVoteFooterView()
@property(nonatomic , strong) UIButton *leftBtn;
@property(nonatomic , strong) UIView *midLineView;
@property(nonatomic , strong) UIButton *rightBtn;

@end

@implementation BPVoteFooterView

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
        [_leftBtn setBackgroundColor:HEXCOLOR(0x0B78E3)];
        [_leftBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.tag = 1000;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
        [_rightBtn setBackgroundColor:HEXCOLOR(0x0B78E3)];
        [_rightBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.tag = 1001;
    }
    return _rightBtn;
}

- (UIView *)midLineView{
    if (!_midLineView) {
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = HEX_RGB_Alpha(0xFFFFFF, 0.43);
    }
    return _midLineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0x0B78E3);
//        [self addSubview:self.midLineView];
//        self.midLineView.sd_layout.topSpaceToView(self, 13).bottomSpaceToView(self, 13).widthIs(DEFAULT_LINE_HEIGHT).centerXEqualToView(self);
        

        [self addSubview:self.leftBtn];
        self.leftBtn.sd_layout.leftEqualToView(self).topEqualToView(self).bottomEqualToView(self).rightSpaceToView(self, 0);
        
//        [self addSubview:self.rightBtn];
//        self.rightBtn.sd_layout.rightEqualToView(self).topEqualToView(self).bottomEqualToView(self).leftSpaceToView(_midLineView, 0);
    }
    return self;
}

- (void)updateViewWithArray:(NSArray *)arr{
    [self.leftBtn setTitle:arr[0] forState:(UIControlStateNormal)];
    [self.rightBtn setTitle:arr[1] forState:(UIControlStateNormal)];
}


- (void)footerBtnClick:(UIButton *)seder{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bpFooterViewBottomBtnDidClick:)]) {
        [self.delegate bpFooterViewBottomBtnDidClick:seder];
    }
}
@end
