//
//  CustomNavigationView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#define BUTTON_HEIGHT 22
#import "CustomNavigationView.h"

@implementation CustomNavigationView

- (UIView *)originNavView{
    if (!_originNavView) {
        _originNavView = [[UIView alloc] init];
    }
    return _originNavView;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_leftBtn setImage:[UIImage imageNamed:@"setting"] forState:(UIControlStateNormal)];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn1{
    if (!_rightBtn1) {
        _rightBtn1 = [[UIButton alloc] init];
        [_rightBtn1 addTarget:self action:@selector(rightBtn1DidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_rightBtn1 setImage:[UIImage imageNamed:@"scan"] forState:(UIControlStateNormal)];
    }
    return _rightBtn1;
}
//- (UIButton *)rightBtn2{
//    if (!_rightBtn2) {
//        _rightBtn2 = [[UIButton alloc] init];
//        [_rightBtn2 addTarget:self action:@selector(rightBtn2DidClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        [_rightBtn2 setImage:[UIImage imageNamed:@"notify"] forState:(UIControlStateNormal)];
//    }
//    return _rightBtn2;
//}

- (UIImageView *)titleImg{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image = [UIImage imageNamed:@"PocketEOS"];
        _titleImg.contentMode = UIViewContentModeRedraw;
    }
    return _titleImg;
}

- (UIView *)changedNavView{
    if (!_changedNavView) {
        _changedNavView = [[UIView alloc] init];
    }
    return _changedNavView;
}

- (UIButton *)changedBtn1{
    if (!_changedBtn1) {
        _changedBtn1 = [[UIButton alloc] init];
        [_changedBtn1 addTarget:self action:@selector(changedBtn1DidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_changedBtn1 setImage:[UIImage imageNamed:@"transfer_icon"] forState:(UIControlStateNormal)];
    }
    return _changedBtn1;
}

- (UIButton *)changedBtn2{
    if (!_changedBtn2) {
        _changedBtn2 = [[UIButton alloc] init];
        [_changedBtn2 addTarget:self action:@selector(changedBtn2DidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_changedBtn2 setImage:[UIImage imageNamed:@"recieve_icon"] forState:(UIControlStateNormal)];
    }
    return _changedBtn2;
}

- (UIButton *)changedBtn3{
    if (!_changedBtn3) {
        _changedBtn3 = [[UIButton alloc] init];
        [_changedBtn3 addTarget:self action:@selector(changedBtn3DidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_changedBtn3 setImage:[UIImage imageNamed:@"redpacket_icon"] forState:(UIControlStateNormal)];
    }
    return _changedBtn3;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 默认的导航栏
        [self addSubview:self.originNavView];
        self.originNavView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [_originNavView addSubview:self.leftBtn];
        self.leftBtn.sd_layout.leftSpaceToView(_originNavView, 15).bottomSpaceToView(_originNavView, 10).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);
        
        [_originNavView addSubview:self.rightBtn1];
        self.rightBtn1.sd_layout.rightSpaceToView(_originNavView, 15).bottomSpaceToView(_originNavView, 10).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);
        
//        [_originNavView addSubview:self.rightBtn2];
//        self.rightBtn2.sd_layout.rightSpaceToView(self.rightBtn1, BUTTON_HEIGHT).bottomSpaceToView(_originNavView, 10).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);
        
        [_originNavView addSubview:self.titleImg];
        self.titleImg.sd_layout.centerXEqualToView(self).bottomSpaceToView(_originNavView, 12).widthIs(95).heightIs(15);
        
        
        // 滑动后的导航栏
        [self addSubview:self.changedNavView];
        self.changedNavView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, -NAVIGATIONBAR_HEIGHT).rightEqualToView(self).heightIs(NAVIGATIONBAR_HEIGHT);
//        self.changedNavView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [_changedNavView addSubview:self.changedBtn1];
        _changedBtn1.sd_layout.leftSpaceToView(_changedNavView, 25).bottomSpaceToView(_changedNavView, 15).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);
        
        [_changedNavView addSubview:self.changedBtn2];
        _changedBtn2.sd_layout.leftSpaceToView(_changedBtn1, 25).bottomSpaceToView(_changedNavView, 15).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);
        
        [_changedNavView addSubview:self.changedBtn3];
        _changedBtn3.sd_layout.leftSpaceToView(_changedBtn2, 25).bottomSpaceToView(_changedNavView, 15).widthIs(BUTTON_HEIGHT).heightIs(BUTTON_HEIGHT);

    }
    return self;
}

- (void)leftBtnDidClick:(UIButton *)sender{
    if (!self.leftBtnDidClickBlock) {
        return;
    }
    self.leftBtnDidClickBlock();
}

- (void)rightBtn1DidClick:(UIButton *)sender{
    if (!self.rightBtn1DidClickBlock) {
        return;
    }
    self.rightBtn1DidClickBlock();
}

//- (void)rightBtn2DidClick:(UIButton *)sender{
//    if (!self.rightBtn2DidClickBlock) {
//        return;
//    }
//    self.rightBtn2DidClickBlock();
//}

- (void)changedBtn1DidClick:(UIButton *)sender{
    if (!self.changedBtn1DidClickBlock) {
        return;
    }
    self.changedBtn1DidClickBlock();
}

- (void)changedBtn2DidClick:(UIButton *)sender{
    if (!self.changedBtn2DidClickBlock) {
        return;
    }
    self.changedBtn2DidClickBlock();
}

- (void)changedBtn3DidClick:(UIButton *)sender{
    if (!self.changedBtn3DidClickBlock) {
        return;
    }
    self.changedBtn3DidClickBlock();
}
@end
