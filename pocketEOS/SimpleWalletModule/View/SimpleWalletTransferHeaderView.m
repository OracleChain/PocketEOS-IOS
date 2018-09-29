//
//  SimpleWalletTransferHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define SimpleWalletTransferHeaderViewItemHeight 44.5

#import "SimpleWalletTransferHeaderView.h"


@interface SimpleWalletTransferHeaderView()

@property(nonatomic , strong) UIView *contentBaseView;

@property(nonatomic , strong) UIImageView *dappAvatarImgView;
@property(nonatomic , strong) BaseLabel1 *amountLabel;
@property(nonatomic , strong) BaseLabel1 *fromLabel;
@property(nonatomic , strong) BaseLabel1 *toLabel;
@property(nonatomic , strong) BaseLabel1 *contractNameLabel;
@property(nonatomic , strong) BaseLabel1 *memoLabel;


@property(nonatomic , strong) BaseSlimLineView *line1;
@property(nonatomic , strong) BaseSlimLineView *line2;
@property(nonatomic , strong) BaseSlimLineView *line3;
@property(nonatomic , strong) BaseSlimLineView *line4;
@property(nonatomic , strong) BaseSlimLineView *line5;



@property(nonatomic , strong) BaseLabel *dappNameLabel;
@property(nonatomic , strong) BaseLabel *amountDetailLabel;
@property(nonatomic , strong) BaseLabel *fromDetailLabel;
@property(nonatomic , strong) BaseLabel *toDetailLabel;
@property(nonatomic , strong) BaseLabel *contractDetailLabel;
@property(nonatomic , strong) BaseLabel *memoDetailLabel;


@property(nonatomic , strong) UILabel *tipLabel;
@end


@implementation SimpleWalletTransferHeaderView


- (UIView *)contentBaseView{
    if (!_contentBaseView) {
        _contentBaseView = [[UIView alloc] init];
    }
    return _contentBaseView;
}

- (UIImageView *)dappAvatarImgView{
    if (!_dappAvatarImgView) {
        _dappAvatarImgView = [[UIImageView alloc] init];
        _dappAvatarImgView.image = [UIImage imageNamed:@"2"];
    }
    return _dappAvatarImgView;
}

- (BaseLabel1 *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[BaseLabel1 alloc] init];
        _amountLabel.text = NSLocalizedString(@"金额", nil);
        _amountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _amountLabel;
}

- (BaseLabel1 *)fromLabel{
    if (!_fromLabel) {
        _fromLabel = [[BaseLabel1 alloc] init];
        _fromLabel.text = NSLocalizedString(@"付款账号", nil);
        _fromLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fromLabel;
}

- (BaseLabel1 *)toLabel{
    if (!_toLabel) {
        _toLabel = [[BaseLabel1 alloc] init];
        _toLabel.text = NSLocalizedString(@"收款账号", nil);
        _toLabel.font = [UIFont systemFontOfSize:14];
    }
    return _toLabel;
}

- (BaseLabel1 *)contractNameLabel{
    if (!_contractNameLabel) {
        _contractNameLabel = [[BaseLabel1 alloc] init];
        _contractNameLabel.text = NSLocalizedString(@"合约名字", nil);
        _contractNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractNameLabel;
}

- (BaseLabel1 *)memoLabel{
    if (!_memoLabel) {
        _memoLabel = [[BaseLabel1 alloc] init];
        _memoLabel.text = NSLocalizedString(@"内容", nil);
        _memoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _memoLabel;
}

- (BaseSlimLineView *)line1{
    if (!_line1) {
        _line1 = [[BaseSlimLineView alloc] init];
    }
    return _line1;
}

- (BaseSlimLineView *)line2{
    if (!_line2) {
        _line2 = [[BaseSlimLineView alloc] init];
    }
    return _line2;
}

- (BaseSlimLineView *)line3{
    if (!_line3) {
        _line3 = [[BaseSlimLineView alloc] init];
    }
    return _line3;
}

- (BaseSlimLineView *)line4{
    if (!_line4) {
        _line4 = [[BaseSlimLineView alloc] init];
    }
    return _line4;
}

- (BaseSlimLineView *)line5{
    if (!_line5) {
        _line5 = [[BaseSlimLineView alloc] init];
    }
    return _line5;
}

- (BaseLabel *)dappNameLabel{
    if (!_dappNameLabel) {
        _dappNameLabel = [[BaseLabel alloc] init];
        _dappNameLabel.textAlignment = NSTextAlignmentRight;
        _dappNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dappNameLabel;
}

- (BaseLabel *)amountDetailLabel{
    if (!_amountDetailLabel) {
        _amountDetailLabel = [[BaseLabel alloc] init];
        _amountDetailLabel.textAlignment = NSTextAlignmentRight;
        _amountDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _amountDetailLabel;
}

- (BaseLabel *)fromDetailLabel{
    if (!_fromDetailLabel) {
        _fromDetailLabel = [[BaseLabel alloc] init];
        _fromDetailLabel.textAlignment = NSTextAlignmentRight;
        _fromDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fromDetailLabel;
}

- (BaseLabel *)toDetailLabel{
    if (!_toDetailLabel) {
        _toDetailLabel = [[BaseLabel alloc] init];
        _toDetailLabel.textAlignment = NSTextAlignmentRight;
        _toDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _toDetailLabel;
}

- (BaseLabel *)contractDetailLabel{
    if (!_contractDetailLabel) {
        _contractDetailLabel = [[BaseLabel alloc] init];
        _contractDetailLabel.textAlignment = NSTextAlignmentRight;
        _contractDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractDetailLabel;
}

- (BaseLabel *)memoDetailLabel{
    if (!_memoDetailLabel) {
        _memoDetailLabel = [[BaseLabel alloc] init];
        _memoDetailLabel.textAlignment = NSTextAlignmentRight;
        _memoDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _memoDetailLabel;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = HEXCOLOR(0x4D7BFE);
        [_confirmBtn setTitle:NSLocalizedString(@"确认授权", nil) forState:(UIControlStateNormal)];
        [_confirmBtn addTarget:self action:@selector(transferHeaderViewconfirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _confirmBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"授权代表您信任该Dapp，PE不对由此造成的损失负责", nil);
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = HEXCOLOR(0x999999);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}


-(void)setModel:(SimpleWalletTransferModel *)model{
    _model = model;
    self.contentBaseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentBaseView];
    self.contentBaseView.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self, 36).rightSpaceToView(self, MARGIN_20);
    
    // dapp name
    [self.contentBaseView addSubview:self.dappAvatarImgView];
    self.dappAvatarImgView.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.contentBaseView, 13).widthIs(30).heightIs(30);
    
    [self.contentBaseView addSubview:self.dappNameLabel];
    self.dappNameLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).centerYEqualToView(self.dappAvatarImgView).leftSpaceToView(self.dappAvatarImgView, MARGIN_20).heightIs(MARGIN_15);
    
    [self.contentBaseView addSubview:self.line1];
    self.line1.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.dappAvatarImgView, MARGIN_15).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    
    // amount
    [self.contentBaseView addSubview:self.amountLabel];
    self.amountLabel.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line1, MARGIN_15).widthIs(100).heightIs(15);
    
    [self.contentBaseView addSubview:self.amountDetailLabel];
    self.amountDetailLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).centerYEqualToView(self.amountLabel).leftSpaceToView(self.amountLabel, MARGIN_20).heightIs(MARGIN_15);
    
    [self.contentBaseView addSubview:self.line2];
    self.line2.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.amountLabel, MARGIN_15).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    
    // from
    [self.contentBaseView addSubview:self.fromLabel];
    self.fromLabel.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line2, MARGIN_15).widthIs(100).heightIs(15);
    
    [self.contentBaseView addSubview:self.fromDetailLabel];
    self.fromDetailLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).centerYEqualToView(self.fromLabel).leftSpaceToView(self.fromLabel, MARGIN_20).heightIs(MARGIN_15);
    
    [self.contentBaseView addSubview:self.line3];
    self.line3.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.fromLabel, MARGIN_15).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    

    // to
    [self.contentBaseView addSubview:self.toLabel];
    self.toLabel.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line3, MARGIN_15).widthIs(100).heightIs(15);
    
    [self.contentBaseView addSubview:self.toDetailLabel];
    self.toDetailLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).centerYEqualToView(self.toLabel).leftSpaceToView(self.toLabel, MARGIN_20).heightIs(MARGIN_15);
    
    [self.contentBaseView addSubview:self.line4];
    self.line4.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.toLabel, MARGIN_15).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    
    // contract
    [self.contentBaseView addSubview:self.contractNameLabel];
    self.contractNameLabel.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line4, MARGIN_15).widthIs(100).heightIs(15);
    
    [self.contentBaseView addSubview:self.contractDetailLabel];
    self.contractDetailLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).centerYEqualToView(self.contractNameLabel).leftSpaceToView(self.contractNameLabel, MARGIN_20).heightIs(MARGIN_15);
    
    [self.contentBaseView addSubview:self.line5];
    self.line5.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.contractNameLabel, MARGIN_15).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    
    // memo
    [self.contentBaseView addSubview:self.memoLabel];
    self.memoLabel.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line5, MARGIN_15).widthIs(100).heightIs(15);
    
    [self.contentBaseView addSubview:self.memoDetailLabel];
    self.memoDetailLabel.sd_layout.rightSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.line5, MARGIN_15).leftSpaceToView(self.memoLabel, MARGIN_20).autoHeightRatio(0);
    
    
    
    
    [self.dappAvatarImgView sd_setImageWithURL: String_To_URL(self.model.dappIcon) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.dappNameLabel.text = self.model.dappName;
    self.amountDetailLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.amount, self.model.symbol];
    self.fromDetailLabel.text = self.model.from;
    self.toDetailLabel.text = self.model.to;
    self.contractDetailLabel.text = self.model.contract;
    self.memoDetailLabel.text = self.model.dappData;
    
    
    [self.contentBaseView setupAutoHeightWithBottomView:self.memoDetailLabel bottomMargin:MARGIN_20];
    
    
    [self addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, MARGIN_20).topSpaceToView(self.contentBaseView, 30).heightIs(46);
    
    [self addSubview:self.tipLabel];
    self.tipLabel.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, MARGIN_20).topSpaceToView(self.confirmBtn, MARGIN_10).autoWidthRatio(0);
    
}




- (void)transferHeaderViewconfirmBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simpleWalletTransferHeaderViewconfirmBtnDidClick)]) {
        [self.delegate simpleWalletTransferHeaderViewconfirmBtnDidClick];
    }
}

@end
