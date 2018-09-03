//
//  DAppExcuteMutipleActionsBaseView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define CONTENT_BASE_VIEW_HEIGHT 283.0f

#import "DAppExcuteMutipleActionsBaseView.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"
#import "DAppExcuteActionsContentCell.h"

@interface DAppExcuteMutipleActionsBaseView()<UIScrollViewDelegate, UITextFieldDelegate>

@property(nonatomic , strong) UIButton *closeBtn;

@property(nonatomic , strong) UILabel *titleLabel;

@property(nonatomic , strong) UIView *line1;

@property(nonatomic , strong) UIView *contentBaseView;

@property(nonatomic , strong) UIScrollView *mainScrollView;

@property(nonatomic , strong) UIPageControl *pageControl;



@property(nonatomic , strong) UIButton *confirmBtn;

/**
 确认按钮的点击次数
 */
@property(nonatomic , assign) NSUInteger *confirmBtnTouchCount;
@end


@implementation DAppExcuteMutipleActionsBaseView

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"dapp_close"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _closeBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"签名内容", nil);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
    }
    return _titleLabel;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line1;
}

- (UIView *)contentBaseView{
    if (!_contentBaseView) {
        _contentBaseView = [[UIView alloc] init];
    }
    return _contentBaseView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_BASE_VIEW_HEIGHT))];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.actionsArray.count, CONTENT_BASE_VIEW_HEIGHT);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        // 设置总页数
        _pageControl.numberOfPages = self.actionsArray.count;
        _pageControl.pageIndicatorTintColor = HEXCOLOR(0xD8D8D8);
        // 设置当前所在页数
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = HEXCOLOR(0x4D7BFE);
        [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.placeholder = NSLocalizedString(@"输入钱包密码", nil);
        _passwordTF.borderStyle = UITextBorderStyleNone;
        _passwordTF.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
        _passwordTF.layer.borderWidth = 1;
        _passwordTF.delegate = self;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.tag = 50001;//设置一个项目中唯一的tag值
    }
    return _passwordTF;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:NSLocalizedString(@"确认签名", nil) forState:(UIControlStateNormal)];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"dAppExcuteMutipleActionsBaseViewpasswordTF" object:nil];
    }
    return self;
}


- (void)updateViewWithArray:(NSArray *)dataArray{
    self.actionsArray = [NSMutableArray arrayWithArray:dataArray];
    
    [self addSubview:self.closeBtn];
    self.closeBtn.sd_layout.leftSpaceToView(self, 16).topSpaceToView(self, MARGIN_20).widthIs(12).heightIs(12);
    
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self, 0).widthIs(150).heightIs(50);
    
    [self addSubview:self.line1];
    self.line1.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.titleLabel, 0).rightSpaceToView(self, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    [self addSubview:self.contentBaseView];
    self.contentBaseView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.line1, 0).rightSpaceToView(self, 0).heightIs(CONTENT_BASE_VIEW_HEIGHT);
    
    // mainScrollView
    [self.contentBaseView addSubview:self.mainScrollView];
    for (int i = 0 ; i < dataArray.count; i++) {
        ExcuteActions *action = self.actionsArray[i];
        DAppExcuteActionsContentCell *cell = [[DAppExcuteActionsContentCell alloc] initWithFrame:(CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_BASE_VIEW_HEIGHT))];
        cell.model = action;
        [self.mainScrollView addSubview:cell];
    }
    
    [self addSubview:self.pageControl];
    self.pageControl.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.mainScrollView, 0).rightSpaceToView(self, 0).heightIs(47.5);
    
    [self addSubview:self.passwordTF];
    self.passwordTF.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self.pageControl, MARGIN_10).rightSpaceToView(self, MARGIN_20).heightIs(40);
    
    [self addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(46);
    _confirmBtnTouchCount = 0;
    
    if (self.actionsArray.count==1) {
        self.confirmBtn.lee_theme
        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
        self.confirmBtn.enabled = YES;
    }else{
        self.confirmBtn.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xD8D8D8))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
        self.confirmBtn.enabled = NO;
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x_offset = scrollView.contentOffset.x;
    NSLog(@"%f", x_offset);
    self.pageControl.currentPage = x_offset / SCREEN_WIDTH;
    if (self.pageControl.currentPage>0) {
        self.confirmBtn.lee_theme
        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
        self.confirmBtn.enabled = YES;
    }
}

- (void)pageControlValueChange:(UIPageControl *)pageControl{
    NSLog(@"%ld", pageControl.currentPage);
}


- (void)closeBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(excuteMutipleActionsCloseBtnDidClick)]) {
        [self.delegate excuteMutipleActionsCloseBtnDidClick];
    }
}


- (void)confirmBtnClick{
    WS(weakSelf);
    if (_confirmBtnTouchCount == 0) {
        [self.passwordTF becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT-380  - 40, SCREEN_WIDTH, 380 + 40);
        }];
        weakSelf.confirmBtn.hidden = YES;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(excuteMutipleActionsConfirmBtnDidClick)]) {
            [self.delegate excuteMutipleActionsConfirmBtnDidClick];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    WS(weakSelf);
    [self endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT-380-80, SCREEN_WIDTH, 380+80);
    }];
    weakSelf.confirmBtn.hidden = NO;
    _confirmBtnTouchCount++;
    
    return YES;
}

- (void)done:(UITextField *)sender{
    WS(weakSelf);
    [self endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT-380-80, SCREEN_WIDTH, 380+80);
    }];
    weakSelf.confirmBtn.hidden = NO;
    _confirmBtnTouchCount++;
}

@end

