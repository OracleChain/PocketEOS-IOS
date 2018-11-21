//
//  AddAccountTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AddAccountTableViewCell.h"

@interface AddAccountTableViewCell()
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic , strong) BaseLabel1 *detailLabel;
@end


@implementation AddAccountTableViewCell

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        _titleLabel.textColor = HEXCOLOR(0x140F26);
    }
    return _titleLabel;
}

- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.sd_cornerRadius = @(19);
    }
    return _avatarImg;
}

- (BaseLabel1 *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel1 alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
//        _detailLabel.textColor = HEXCOLOR(0x6C7B8A);
    }
    return _detailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
        self.contentView.sd_layout.leftSpaceToView(self, MARGIN_15).rightSpaceToView(self, MARGIN_15).topSpaceToView(self, 5).bottomSpaceToView(self, 5);
        self.contentView.sd_cornerRadius = @4;
        self.contentView.layer.borderWidth = 1;
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            self.contentView.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor ;
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            self.contentView.layer.borderColor = HEXCOLOR(0x999999).CGColor ;
        }
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(38).heightEqualToWidth();
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, MARGIN_20).topSpaceToView(self.contentView, 29).heightIs(18).rightSpaceToView(self.contentView, MARGIN_20);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftSpaceToView(_avatarImg, MARGIN_20).topSpaceToView(self.titleLabel, 6).heightIs(15).rightSpaceToView(self.contentView, MARGIN_20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(OptionModel *)model{
    _model = model;
    _titleLabel.text = _model.optionName;
    _detailLabel.text = _model.detail;
    _avatarImg.lee_theme.LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:model.optionNormalIcon]).LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:model.optionBlackBoxNormalIcon]);
}

@end
