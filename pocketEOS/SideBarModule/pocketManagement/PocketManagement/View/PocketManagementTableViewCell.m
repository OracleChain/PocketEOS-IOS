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
@property(nonatomic, strong) UIImageView *mainAccountImg;
@end


@implementation PocketManagementTableViewCell
- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.sd_cornerRadius = @(6);
    }
    return _avatarImg;
}

- (UIImageView *)mainAccountImg{
    if (!_mainAccountImg) {
        _mainAccountImg = [[UIImageView alloc] init];
        _mainAccountImg.image = [UIImage imageNamed:@"mainAccount"];
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
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(30).heightEqualToWidth();
        
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, 10).centerYEqualToView(_avatarImg).widthIs(100).heightIs(21);
        
        [self.contentView addSubview:self.mainAccountImg];
        self.mainAccountImg.sd_layout.leftSpaceToView(self.titleLabel, 5).centerYEqualToView(self.contentView).widthIs(16).heightIs(14);
        
        self.rightIconImgName = @"right_icon_blue";
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, 20).widthIs(13).heightIs(10).centerYEqualToView(self.contentView);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(AccountInfo *)model{
    _model = model;
    _titleLabel.text = _model.account_name;
    [_avatarImg sd_setImageWithURL: String_To_URL(model.account_name) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    if ([_model.is_main_account isEqualToString:@"1"]) {
        _mainAccountImg.hidden = NO;
    }else{
        _mainAccountImg.hidden = YES;
    }
    
    if (model.selected == YES) {
        self.rightIconImageView.hidden = NO;
    }else{
        self.rightIconImageView.hidden = YES;
    }
}


@end
