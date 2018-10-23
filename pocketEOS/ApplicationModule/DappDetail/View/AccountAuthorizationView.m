//
//  AccountAuthorizationView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AccountAuthorizationView.h"

@interface AccountAuthorizationView()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic , strong) UIView *topBaseView;
@property(nonatomic , strong) UIView *bottomBaseView;


@property(nonatomic , strong) BaseLabel *titlelabel;
@property(nonatomic , strong) BaseSlimLineView *line1;

@property(nonatomic , strong) BaseLabel1 *accountNameLabel;
@property(nonatomic , strong) BaseLabel1 *memoLabel;
@property(nonatomic , strong) BaseLabel1 *passwordLabel;

@property(nonatomic , strong) BaseLabel *accountNameDetailLabel;
@property(nonatomic , strong) BaseLabel *memoDetailLabel;



@property(nonatomic , strong) UIButton *confirmBtn;

@end



@implementation AccountAuthorizationView

- (UIView *)topBaseView{
    if (!_topBaseView) {
        _topBaseView = [[UIView alloc] init];
        _topBaseView.userInteractionEnabled = YES;
        _topBaseView.backgroundColor = [UIColor blackColor];
        _topBaseView.alpha = 0.5;
        
    }
    return _topBaseView;
}

- (UIView *)bottomBaseView{
    if (!_bottomBaseView) {
        _bottomBaseView = [[UIView alloc] init];
        _bottomBaseView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _bottomBaseView;
}

- (BaseLabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [[BaseLabel alloc] init];
        _titlelabel.text = NSLocalizedString(@"账户授权", nil);
        _titlelabel.font = [UIFont systemFontOfSize:15];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}

- (BaseSlimLineView *)line1{
    if (!_line1) {
        _line1 = [[BaseSlimLineView alloc] init];
    }
    return _line1;
}

- (BaseLabel1 *)accountNameLabel{
    if (!_accountNameLabel) {
        _accountNameLabel = [[BaseLabel1 alloc] init];
        _accountNameLabel.text = NSLocalizedString(@"账户", nil);
        _accountNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountNameLabel;
}

- (BaseLabel1 *)memoLabel{
    if (!_memoLabel) {
        _memoLabel = [[BaseLabel1 alloc] init];
        _memoLabel.text = NSLocalizedString(@"备注", nil);
        _memoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _memoLabel;
}

- (BaseLabel1 *)passwordLabel{
    if (!_passwordLabel) {
        _passwordLabel = [[BaseLabel1 alloc] init];
        _passwordLabel.text = NSLocalizedString(@"密码", nil);
        _passwordLabel.font = [UIFont systemFontOfSize:14];
    }
    return _passwordLabel;
}


- (BaseLabel *)accountNameDetailLabel{
    if (!_accountNameDetailLabel) {
        _accountNameDetailLabel = [[BaseLabel alloc] init];
        _accountNameDetailLabel.font = [UIFont systemFontOfSize:14];
        _accountNameDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _accountNameDetailLabel;
}

- (BaseLabel *)memoDetailLabel{
    if (!_memoDetailLabel) {
        _memoDetailLabel = [[BaseLabel alloc] init];
        _memoDetailLabel.font = [UIFont systemFontOfSize:14];
        _memoDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _memoDetailLabel;
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

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:NSLocalizedString(@"确认授权", nil) forState:(UIControlStateNormal)];
        [_confirmBtn setFont:[UIFont systemFontOfSize:15]];
        [_confirmBtn addTarget:self action:@selector(confirmAuthorizationBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _confirmBtn.backgroundColor = HEXCOLOR(0x0B78E3);
    }
    return _confirmBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self.topBaseView addGestureRecognizer:tap];
    }
    return self;
}



- (void)updateViewWithModel:(OptionModel *)model{
    
    [self addSubview:self.topBaseView];
    self.topBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-251);
    
    [self addSubview:self.bottomBaseView];
    self.bottomBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(251);
    
    
    [self.bottomBaseView addSubview:self.titlelabel];
    self.titlelabel.sd_layout.topSpaceToView(self.bottomBaseView, MARGIN_15).leftSpaceToView(self.bottomBaseView, MARGIN_20).rightSpaceToView(self.bottomBaseView, MARGIN_20).heightIs(MARGIN_15);

    [self.bottomBaseView addSubview:self.line1];
    self.line1.sd_layout.leftSpaceToView(self.bottomBaseView, 0 ).rightSpaceToView(self.bottomBaseView, 0).topSpaceToView(self.titlelabel, MARGIN_15).heightIs(DEFAULT_LINE_HEIGHT);
    
    [self.bottomBaseView addSubview:self.accountNameLabel];
    self.accountNameLabel.sd_layout.leftSpaceToView(self.bottomBaseView , MARGIN_20).topSpaceToView(self.line1 , MARGIN_20).widthIs(100).heightIs(MARGIN_15);
    
    [self.bottomBaseView addSubview:self.accountNameDetailLabel];
    self.accountNameDetailLabel.sd_layout.rightSpaceToView(self.bottomBaseView, MARGIN_20).centerYEqualToView(self.accountNameLabel).heightIs(MARGIN_15).leftSpaceToView(self.accountNameLabel, MARGIN_20);
    
    [self.bottomBaseView addSubview:self.memoLabel];
    self.memoLabel.sd_layout.leftSpaceToView(self.bottomBaseView, MARGIN_20).topSpaceToView(self.accountNameLabel, MARGIN_20).widthIs(100).heightIs(MARGIN_15);
    
    [self.bottomBaseView addSubview:self.memoDetailLabel];
    self.memoDetailLabel.sd_layout.rightSpaceToView(self.bottomBaseView, MARGIN_20).centerYEqualToView(self.memoLabel).heightIs(MARGIN_15).leftSpaceToView(self.memoLabel,  MARGIN_20);
    
    [self.bottomBaseView addSubview:self.passwordLabel];
    self.passwordLabel.sd_layout.leftSpaceToView(self.bottomBaseView, MARGIN_20).topSpaceToView(self.memoLabel, MARGIN_20).widthIs(100).heightIs(MARGIN_15);
    
    [self.bottomBaseView addSubview:self.passwordTF];
    self.passwordTF.sd_layout.rightSpaceToView(self.bottomBaseView, MARGIN_20).topSpaceToView(self.memoLabel, MARGIN_15).leftSpaceToView(self.passwordLabel, MARGIN_20).heightIs(40);
    
    [self.bottomBaseView addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.leftSpaceToView(self.bottomBaseView, 0).rightSpaceToView(self.bottomBaseView, 0).bottomSpaceToView(self.bottomBaseView, 0).heightIs(48);
    
    
    
    
    self.accountNameDetailLabel.text = model.optionName;
    self.memoDetailLabel.text = model.detail;
    
}

- (void)dismiss{
    [self removeFromSuperview];
    self.passwordTF.text = nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.bottomBaseView]) {
        return NO;
        
    }else{
        return YES;
    }
}

- (void)confirmAuthorizationBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountAuthorizationViewConfirmBtnDidClick)]) {
        [self.delegate accountAuthorizationViewConfirmBtnDidClick];
    }
}

@end
