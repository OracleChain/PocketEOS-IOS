//
//  PocketManagementTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PocketManagementTableViewCell.h"

@interface PocketManagementTableViewCell()

@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) UIImageView *protectImg;// 保护隐私
@end


@implementation PocketManagementTableViewCell
- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.sd_cornerRadius = @(6);
    }
    return _avatarImg;
}

- (UIImageView *)protectImg{
    if (!_protectImg) {
        _protectImg = [[UIImageView alloc] init];
        _protectImg.image = [UIImage imageNamed:@"protectAccount"];
    }
    return _protectImg;
}


- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(40).heightEqualToWidth();
        
        [self.contentView addSubview:self.protectImg];
        self.protectImg.sd_layout.leftSpaceToView(_avatarImg, -10).topSpaceToView(_avatarImg, -MARGIN_15).widthIs(18).heightIs(22);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, 10).centerYEqualToView(_avatarImg).rightSpaceToView(self.contentView, MARGIN_20).heightIs(21);
        self.selectionStyle = UITableViewCellAccessoryNone;
    }
    return self;
}

-(void)setModel:(AccountInfo *)model{
    _model = model;
    _titleLabel.text = _model.account_name;
    [_avatarImg sd_setImageWithURL: String_To_URL(model.account_name) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    if ([_model.is_privacy_policy isEqualToString:@"0"]) {
        _protectImg.hidden = YES;
    }else if ([_model.is_privacy_policy isEqualToString:@"1"]){
        _protectImg.hidden = NO;
    }
}


@end
