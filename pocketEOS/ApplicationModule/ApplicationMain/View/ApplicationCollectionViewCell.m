//
//  ApplicationCollectionViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ApplicationCollectionViewCell.h"
#import "Application.h"


@implementation ApplicationCollectionViewCell

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
    }
    return _img;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x999999);
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descriptionLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(50).heightIs(50);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_img, 10 ).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 22).heightIs(18);
        
        [self.contentView addSubview:self.descriptionLabel];
        self.descriptionLabel.sd_layout.leftSpaceToView(_img, 10).topSpaceToView(_titleLabel, 8).rightSpaceToView(self.contentView, 2).heightIs(13);
        
        
    }
    return self;
}

- (void)updateViewWithModel:(Application *)model{
    [_img sd_setImageWithURL: String_To_URL(VALIDATE_STRING(model.applyIcon) )  placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    _titleLabel.text = model.applyName;
    _descriptionLabel.text = model.applyDetails;
}


@end
