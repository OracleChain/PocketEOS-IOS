//
//  GeneratePrivateKeyView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GeneratePrivateKeyView.h"

@interface GeneratePrivateKeyView ()<UIGestureRecognizerDelegate>
@property(nonatomic , strong) UIView *alphaBackgroundView;// black alpha 0.5
@property(nonatomic , strong) UIView *contentBackgroundView;


@property(nonatomic , strong) UILabel *titleLabel;

@property(nonatomic , strong) UITextView *tipTextView;
@property(nonatomic , strong) BaseConfirmButton *confirmBtn;

@end

@implementation GeneratePrivateKeyView

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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.textColor = HEXCOLOR(0x222222);
        _contentTextView.backgroundColor = HEXCOLOR(0xF7F7F7);
        
    }
    return _contentTextView;
}


- (UITextView *)tipTextView{
    if (!_tipTextView) {
        _tipTextView = [[UITextView alloc] init];
        _tipTextView.font = [UIFont systemFontOfSize:14];
        _tipTextView.textColor = HEXCOLOR(0xFF3232);
        _tipTextView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _tipTextView;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
        [_confirmBtn setBackgroundColor:HEXCOLOR(0x4D7BFE)];
        [_confirmBtn setTitle:NSLocalizedString(@"复制私钥", nil) forState:(UIControlStateNormal)];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
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
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName:HEXCOLOR(0xFF3232)
                                 };
    CGSize detailContentSize = [NSObject getStringRectInTextViewWithString:model.detail InTextView:self.contentTextView withAttributesDict:attributes];
    
    
    
    self.contentBackgroundView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(contentBackgroundViewHeight);
    
    [self.contentBackgroundView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.contentBackgroundView, 25).heightIs(24).leftEqualToView(self.contentBackgroundView).rightEqualToView(self.contentBackgroundView);
    
    [self.contentBackgroundView addSubview:self.contentTextView];
    self.contentTextView.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.titleLabel, 25).leftSpaceToView(self.contentBackgroundView, MARGIN_20).rightSpaceToView(self.contentBackgroundView, MARGIN_20).heightIs(61); // .heightIs(detailContentSize.height)
    
    [self.contentBackgroundView addSubview:self.tipTextView];
    self.tipTextView.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.contentTextView, MARGIN_20).leftSpaceToView(self.contentBackgroundView, MARGIN_20).rightSpaceToView(self.contentBackgroundView, MARGIN_20).heightIs(detailContentSize.height); // .heightIs(detailContentSize.height)
    
    [self.contentBackgroundView addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.centerXEqualToView(self.contentBackgroundView).topSpaceToView(self.tipTextView, 30).leftSpaceToView(self.contentBackgroundView, MARGIN_20).rightSpaceToView(self.contentBackgroundView, MARGIN_20).heightIs(39);
    
    
    self.titleLabel.text = model.optionName;
    self.tipTextView.text = model.detail;
    
    
    [self.contentBackgroundView setupAutoHeightWithBottomView: self.confirmBtn bottomMargin: 30];

    
}








- (void)confirmBtnClick:(UIButton *)sender{
   
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentTextView.text;
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
    
    [self dismiss];
}




- (void)dismiss{
    [self removeFromSuperview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.contentBackgroundView]) {
        return NO;
    }else{
        return YES;
    }
}

@end
