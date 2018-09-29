//
//  ExcuteActionsHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ExcuteActionsHeaderView.h"

@implementation ExcuteActionsHeaderView


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

- (BaseLabel1 *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[BaseLabel1 alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descriptionLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self, 20).centerYEqualToView(self).widthIs(50).heightIs(50);
        
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_img, 10 ).rightSpaceToView(self, 20).topSpaceToView(self, 22).heightIs(18);
        
        [self addSubview:self.descriptionLabel];
        self.descriptionLabel.sd_layout.leftSpaceToView(_img, 10).topSpaceToView(_titleLabel, 8).rightSpaceToView(self, 2).heightIs(13);
        
        
    }
    return self;
}

- (void)updateViewWithModel:(ExcuteActionsResult *)model{
    [_img sd_setImageWithURL: String_To_URL(VALIDATE_STRING(model.dappIcon) )  placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    _titleLabel.text = model.dappName;
    _descriptionLabel.text = model.desc;
}




@end
