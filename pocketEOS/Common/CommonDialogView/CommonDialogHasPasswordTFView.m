//
//  CommonDialogHasPasswordTFView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CommonDialogHasPasswordTFView.h"

@interface CommonDialogHasPasswordTFView()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property(nonatomic , strong) UIView *alphaBackgroundView;// black alpha 0.5
@property(nonatomic , strong) UIView *contentBackgroundView;
@property(nonatomic , strong) UITextView *contentTextView;
@property(nonatomic , strong) UIImageView *avatarImg;

@property(nonatomic , strong) UIView *lineView;
@property(nonatomic , strong) UIButton *skipBtn;
@property(nonatomic , strong) UIButton *updateBtn;
@property(nonatomic , strong) UIView *midLineView;



@end


@implementation CommonDialogHasPasswordTFView

- (UIView *)alphaBackgroundView{
    if (!_alphaBackgroundView) {
        _alphaBackgroundView = [[UIView alloc] init];
        _alphaBackgroundView.backgroundColor = [UIColor blackColor];
        _alphaBackgroundView.alpha = 0.5;
    }
    return _alphaBackgroundView;
}

- (UIView *)contentBackgroundView{
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc] init];
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _contentBackgroundView.layer.masksToBounds = YES;
        _contentBackgroundView.layer.cornerRadius = 6;
    }
    return _contentBackgroundView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.textColor = HEXCOLOR(0x666666);
        _contentTextView.editable =NO;
    }
    return _contentTextView;
}

- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.image = [UIImage imageNamed:@"account_default_blue"];
    }
    return _avatarImg;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _lineView;
}

- (UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc] init];
        [_skipBtn setTitle:NSLocalizedString(@"取消", nil)forState:(UIControlStateNormal)];
        [_skipBtn setTitleColor:HEXCOLOR(0x999999) forState:(UIControlStateNormal)];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_skipBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _skipBtn;
}

- (UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [[UIButton alloc] init];
        [_updateBtn setTitle:NSLocalizedString(@"确定", nil)forState:(UIControlStateNormal)];
        [_updateBtn setTitleColor:HEXCOLOR(0x4D7BFE) forState:(UIControlStateNormal)];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _updateBtn;
}

- (UIView *)midLineView{
    if (!_midLineView) {
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _midLineView;
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
    }
    return _passwordTF;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.alphaBackgroundView.frame = frame;
        [self addSubview:self.alphaBackgroundView];
    }
    return self;
}

-(void)setModel:(OptionModel *)model{
    CGFloat contentBackgroundViewHeight = 290;
    [self addSubview:self.contentBackgroundView];
    self.contentBackgroundView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(contentBackgroundViewHeight);
    
    [self.contentBackgroundView addSubview:self.contentTextView];
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName:HEXCOLOR(0x666666)
                                 };
    CGSize detailContentSize = [NSObject getStringRectInTextViewWithString:model.detail InTextView:self.contentTextView withAttributesDict:attributes];
    
    [self.contentBackgroundView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.avatarImg, 17.7).heightIs(24).leftEqualToView(self.contentBackgroundView).rightEqualToView(self.contentBackgroundView);
    
//    [self.contentBackgroundView addSubview:self.contentTextView];
    self.contentTextView.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.titleLabel, 8).leftSpaceToView(self.contentBackgroundView, MARGIN_20).rightSpaceToView(self.contentBackgroundView, MARGIN_20).heightIs(detailContentSize.height); // .heightIs(detailContentSize.height)  .heightIs(66)
    
    
    [self.contentBackgroundView addSubview:self.passwordTF];
    self.passwordTF.sd_layout.leftSpaceToView(self.contentBackgroundView, MARGIN_20).rightSpaceToView(self.contentBackgroundView, MARGIN_20).topSpaceToView(self.contentTextView, MARGIN_20).heightIs(44);
    
    
    [self.contentBackgroundView addSubview:self.lineView];
    self.lineView.sd_layout.leftEqualToView(self.contentBackgroundView).rightEqualToView(self.contentBackgroundView).topSpaceToView(self.passwordTF, MARGIN_20).heightIs(DEFAULT_LINE_HEIGHT);
    
    [self.contentBackgroundView addSubview:self.midLineView];
    self.midLineView.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.lineView, 0).heightIs(52.5).widthIs(DEFAULT_LINE_HEIGHT);
    
    [self.contentBackgroundView addSubview:self.skipBtn];
    self.skipBtn.sd_layout.leftSpaceToView(self.contentBackgroundView, 0).rightSpaceToView(self.midLineView, 0).topSpaceToView(self.lineView, 0).heightIs(52.5);
    
    [self.contentBackgroundView addSubview:self.updateBtn];
    self.updateBtn.sd_layout.leftSpaceToView(self.midLineView, 0).rightSpaceToView(self.contentBackgroundView, 0).topSpaceToView(self.lineView, DEFAULT_LINE_HEIGHT).heightIs(52.5);
    
    self.titleLabel.text = model.optionName;
    self.contentTextView.text = model.detail;
    
    [self.contentBackgroundView setupAutoHeightWithBottomView: self.midLineView bottomMargin: 0];
}

- (void)skipBtnClick:(UIButton *)sender{
//    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonDialogHasPasswordTFViewSkipBtnDidClick:)]) {
        [self.delegate commonDialogHasPasswordTFViewSkipBtnDidClick:sender];
    }
}

- (void)updateBtnClick:(UIButton *)sender{
//    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonDialogHasPasswordTFViewConfirmBtnDidClick:)]) {
        [self.delegate commonDialogHasPasswordTFViewConfirmBtnDidClick:sender];
    }
}

- (void)dismiss{
    [self removeFromSuperview];
    self.passwordTF.text = nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.contentBackgroundView]) {
        return NO;
    }else{
        return YES;
    }
}


@end
