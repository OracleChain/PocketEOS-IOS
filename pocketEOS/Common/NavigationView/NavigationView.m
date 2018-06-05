//
//  NavigationView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UIImageView *)titleImg{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
    }
    return _titleImg;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_rightBtn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
        _rightBtn.lee_theme
        .LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A), UIControlStateNormal)
        .LeeAddButtonTitleColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF), UIControlStateNormal);
    }
    return _rightBtn;
}

- (UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc] init];
    }
    return _rightImg;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview: self.leftBtn];
        self.leftBtn.sd_layout.leftSpaceToView(self, 6 ).bottomSpaceToView(self, 5).widthIs(30).heightIs(30);
        
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.bottomSpaceToView(self, 10).centerXEqualToView(self).heightIs(20);
        
        [self addSubview:self.titleImg];
        self.titleImg.sd_layout.centerXEqualToView(self).bottomSpaceToView(self, 10).widthIs(120).heightIs(20);
        
        [self addSubview:self.rightBtn];
        self.rightBtn.sd_layout.rightSpaceToView(self, 15).bottomSpaceToView(self, 5).widthIs(40).heightIs(30);
    }
    return self;
}


+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName title:(NSString *)title rightBtnImgName:(NSString *)rightImgName delegate:(id<NavigationViewDelegate>)delegate{
    
    NavigationView *navView = [[self alloc] initWithFrame:frame];
    [navView.leftBtn setImage:[UIImage imageNamed: leftImgName] forState:(UIControlStateNormal)];
    navView.titleLabel.text = title;
    [navView.rightBtn setImage:[UIImage imageNamed: rightImgName] forState:(UIControlStateNormal)];
    navView.delegate = delegate;
    
    if (IsStrEmpty(rightImgName)) {
        navView.rightBtn.hidden = YES;
    }
    return navView;
}

/**
 导航栏 (左button为图片 + 标题 + 右 button 为文字)
 */
+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName title:(NSString *)title rightBtnTitleName:(NSString *)rightBtnTitleName delegate:(id<NavigationViewDelegate>)delegate{
    NavigationView *navView = [[self alloc] initWithFrame:frame];
    [navView.leftBtn setImage:[UIImage imageNamed: leftImgName] forState:(UIControlStateNormal)];
    navView.titleLabel.text = title;
    [navView.rightBtn setTitle:rightBtnTitleName forState:(UIControlStateNormal)];
    navView.rightBtn.font = [UIFont systemFontOfSize:17];
    
    
    
    navView.delegate = delegate;
    if (IsStrEmpty(rightBtnTitleName)) {
        navView.rightBtn.hidden = YES;
    }
    return navView;
}

/**
 导航栏 (左右的按键均为图片 + 标题为图片)
 */
+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName titleImage:(NSString *)titleImage rightBtnImgName:(NSString *)rightBtnImgName delegate:(id<NavigationViewDelegate>)delegate{
    NavigationView *navView = [[self alloc] initWithFrame:frame];
    navView.backgroundColor = [UIColor clearColor];
    [navView.leftBtn setImage:[UIImage imageNamed: leftImgName] forState:(UIControlStateNormal)];
    navView.titleImg.image = [UIImage imageNamed: titleImage];
    [navView.rightBtn setImage:[UIImage imageNamed: rightBtnImgName] forState:(UIControlStateNormal)];
    navView.rightBtn.font = [UIFont systemFontOfSize:14];
    [navView.rightBtn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
    
    navView.delegate = delegate;
    if (IsStrEmpty(rightBtnImgName)) {
        navView.rightBtn.hidden = YES;
    }
    return navView;
}

/**
 导航栏 (左右的按键均为图片 + 标题为图片 , 右侧的图片可以改变)
 */
- (instancetype)initNavigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName titleImage:(NSString *)titleImage rightImgName:(NSString *)rightImgName delegate:(id<NavigationViewDelegate>)delegate{
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.leftBtn setImage:[UIImage imageNamed: leftImgName] forState:(UIControlStateNormal)];
        self.titleImg.image = [UIImage imageNamed: titleImage];
        self.delegate = delegate;
        
        self.titleImg.sd_layout.centerXEqualToView(self).bottomSpaceToView(self, 12).widthIs(95).heightIs(15);
        [self addSubview: self.rightImg];
        self.rightImg.sd_layout.rightSpaceToView(self, 10).bottomSpaceToView(self, 10).widthIs(20).heightIs(20);
        self.rightImg.image = [UIImage imageNamed:rightImgName];
    
    }
    return self;
}
- (void)leftBtnDidClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftBtnDidClick)]) {
        [self.delegate leftBtnDidClick];
    }
}

- (void)rightBtnDidClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightBtnDidClick)]) {
        [self.delegate rightBtnDidClick];
    }
}
@end
