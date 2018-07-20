//
//  CustomAssestsTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CustomAssestsTableViewCell.h"

@interface CustomAssestsTableViewCell()
@property(nonatomic, strong) UIImageView *avatarImg;
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic , strong) BaseLabel1 *detailLabel;
@property(nonatomic, strong) UIImageView *trashImg;
@end

@implementation CustomAssestsTableViewCell

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

- (BaseLabel1 *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel1 alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}

- (UIImageView *)trashImg{
    if (!_trashImg) {
        _trashImg = [[UIImageView alloc] init];
        _trashImg.image = [UIImage imageNamed:@"trash_gray"];
        _trashImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trashImgTap)];
        [_trashImg addGestureRecognizer:tap];
    }
    return _trashImg;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(40).heightEqualToWidth();
        
        [self.contentView addSubview:self.trashImg];
        self.trashImg.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).heightIs(18).widthIs(18);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_avatarImg, 12).rightSpaceToView(self.trashImg, MARGIN_20).topSpaceToView(self.contentView, 18).heightIs(15);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftSpaceToView(_avatarImg, 12).rightSpaceToView(self.trashImg, MARGIN_20).topSpaceToView(self.titleLabel, 6).heightIs(12);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(CustomToken *)model{
    _model = model;
    [_avatarImg sd_setImageWithURL: String_To_URL(model.iconUrl) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    _titleLabel.text = model.assetName;
    _detailLabel.text = model.contractName;
}

- (void)trashImgTap{
    if (!self.onTrashImageDidTapBlock) {
        return;
    }
    self.onTrashImageDidTapBlock(_model);
}


@end
