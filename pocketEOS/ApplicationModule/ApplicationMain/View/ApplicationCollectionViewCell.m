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
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x999999);
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _descriptionLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self, 20).centerYEqualToView(self).widthIs(34).heightIs(34);
        
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_img, 10 ).rightSpaceToView(self, 20).topEqualToView(_img).heightIs(18);
        
        [self addSubview:self.descriptionLabel];
        self.descriptionLabel.sd_layout.leftSpaceToView(_img, 10).topSpaceToView(_titleLabel, 0).rightSpaceToView(self, 20).heightIs(17);
        
    }
    return self;
}

- (void)updateViewWithModel:(Application *)model{
    [_img sd_setImageWithURL: String_To_URL(VALIDATE_STRING(model.applyIcon) )  placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    _titleLabel.text = model.applyName;
    _descriptionLabel.text = model.applyDetails;
}


@end
