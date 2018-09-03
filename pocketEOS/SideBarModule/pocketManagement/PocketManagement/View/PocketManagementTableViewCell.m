//
//  PocketManagementTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PocketManagementTableViewCell.h"

@interface PocketManagementTableViewCell()
@property(nonatomic , strong) UIImageView *mainAccountImg;
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic , strong) UIImageView *selectImg;
@property(nonatomic , strong) BaseLabel1 *detailLabel;
@property(nonatomic , strong) BaseSlimLineView *line1;
@property(nonatomic , strong) BaseLabel1 *tipLabel;
@property(nonatomic , strong) UIImageView *rightArrowImg;
@property(nonatomic , strong) UIButton *tipLabelTapBtn;
@end


@implementation PocketManagementTableViewCell

- (UIImageView *)mainAccountImg{
    if (!_mainAccountImg) {
        _mainAccountImg = [[UIImageView alloc] init];
        _mainAccountImg.image= [UIImage imageNamed:@"mainAccount"];
        _mainAccountImg.hidden = YES;
    }
    return _mainAccountImg;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.sd_cornerRadius = @(6);
    }
    return _avatarImg;
}

- (UIImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [[UIImageView alloc] init];
        _selectImg.userInteractionEnabled = YES;
    }
    return _selectImg;
}

- (BaseLabel1 *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel1 alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}

- (BaseSlimLineView *)line1{
    if (!_line1) {
        _line1 = [[BaseSlimLineView alloc] init];
    }
    return _line1;
}

- (BaseLabel1 *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[BaseLabel1 alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

- (UIImageView *)rightArrowImg{
    if (!_rightArrowImg) {
        _rightArrowImg = [[UIImageView alloc] init];
        _rightArrowImg.image = [UIImage imageNamed:@"right_arrow_gray"];
    }
    return _rightArrowImg;
}

- (UIButton *)tipLabelTapBtn{
    if (!_tipLabelTapBtn) {
        _tipLabelTapBtn = [[UIButton alloc] init];
        [_tipLabelTapBtn addTarget:self action:@selector(tipLabelTapBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _tipLabelTapBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
        self.contentView.sd_layout.leftSpaceToView(self, MARGIN_15).rightSpaceToView(self, MARGIN_15).topSpaceToView(self, 5).bottomSpaceToView(self, 5);
        self.contentView.sd_cornerRadius = @4;
        self.contentView.layer.borderWidth = 1;
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            self.contentView.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor ;
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            self.contentView.layer.borderColor = HEXCOLOR(0x999999).CGColor ;
        }
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, 8).topSpaceToView(self.contentView, 12).widthIs(38).heightEqualToWidth();
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, MARGIN_10).topSpaceToView(self.contentView, 14).heightIs(18);
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
        
        [self.contentView addSubview:self.mainAccountImg];
        self.mainAccountImg.sd_layout.leftSpaceToView(self.titleLabel, 6).centerYEqualToView(self.titleLabel).widthIs(16).heightIs(14);

      
        self.rightIconImgName = @"right_icon_blue";
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, MARGIN_20).widthIs(16).heightIs(16);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftSpaceToView(_avatarImg, MARGIN_10).topSpaceToView(self.titleLabel, 6).heightIs(15).widthIs(200);
        
        
        [self.contentView addSubview:self.line1];
        self.line1.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.avatarImg, 12).heightIs(DEFAULT_LINE_HEIGHT);
        
        [self.contentView addSubview:self.tipLabel];
        self.tipLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_15).topSpaceToView(self.line1, MARGIN_10).heightIs(15).widthIs(200);
        
        [self.contentView addSubview:self.rightArrowImg];
        self.rightArrowImg.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).bottomSpaceToView(self.contentView, 13).widthIs(7).heightIs(13);
        
        [self.contentView addSubview:self.tipLabelTapBtn];
        self.tipLabelTapBtn.sd_layout.leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).topSpaceToView(self.line1, 0).rightSpaceToView(self.contentView, 0);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



-(void)setModel:(AccountInfo *)model{
    _model = model;
    _titleLabel.text = _model.account_name;

    if ([model.is_main_account isEqualToString:@"1"]) {
        _mainAccountImg.hidden = NO;
    }else{
        _mainAccountImg.hidden = YES;
    }
    
    [_avatarImg sd_setImageWithURL: String_To_URL(model.account_name) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    
    if (model.account_owner_public_key.length > 6) {
        _detailLabel.text = NSLocalizedString(@"Active权限＋Owner权限", nil);
    }else{
        _detailLabel.text = NSLocalizedString(@"Active权限", nil);
    }
    
    _tipLabel.text = NSLocalizedString(@"账号详情", nil);
    
    if (model.selected == YES) {
        self.rightIconImageView.image = [UIImage imageNamed:@"circleWithRight_blue"];
    }else{
        self.rightIconImageView.image = [UIImage imageNamed:@"circleWithoutRight_gray"];
    }
}

- (void)tipLabelTapBtnClick{
    if (!self.tipLabelTapBtnClickBlock) {
        return;
    }
    self.tipLabelTapBtnClickBlock(self.model);
}

@end
