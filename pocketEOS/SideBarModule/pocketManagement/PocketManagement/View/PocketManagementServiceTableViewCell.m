//
//  PocketManagementServiceTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/3.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PocketManagementServiceTableViewCell.h"

@interface PocketManagementServiceTableViewCell()
@property(nonatomic, strong) UIImageView *avatarImg;

@end


@implementation PocketManagementServiceTableViewCell

- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
    }
    return _avatarImg;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, 28).centerYEqualToView(self.contentView).widthIs(14).heightEqualToWidth();
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, 10).centerYEqualToView(_avatarImg).rightSpaceToView(self.contentView, MARGIN_20).heightIs(21);
        
       
        
        self.rightIconImgName = @"right_arrow_gray";
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, 20).widthIs(7).heightIs(14).centerYEqualToView(self.contentView);
    }
    return self;
}

-(void)setModel:(OptionModel *)model{
    _model = model;
    _titleLabel.text = _model.optionName;
    _avatarImg.image = [UIImage imageNamed:model.optionNormalIcon];
    
}


@end
