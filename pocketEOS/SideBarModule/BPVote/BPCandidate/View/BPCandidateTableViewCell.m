//
//  BPCandidateTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateTableViewCell.h"

@interface BPCandidateTableViewCell()
@property(nonatomic , strong) UIImageView *avatarImgView;
@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UILabel *detailLabel;
@property(nonatomic , strong) UIImageView *rectImg;
@end

@implementation BPCandidateTableViewCell

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.sd_cornerRadius = @6;
        _avatarImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageTap)];
        [_avatarImgView addGestureRecognizer:tap];
    }
    return _avatarImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0xFFFFFF);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = HEX_RGB_Alpha(0xFFFFFF, 0.7);
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (UIImageView *)rectImg{
    if (!_rectImg) {
        _rectImg = [[UIImageView alloc] init];
        _rectImg.userInteractionEnabled = YES;
    }
    return _rectImg;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        self.contentView.backgroundColor = HEXCOLOR(0x000000);
        
        [self.contentView addSubview:self.rectImg];
        self.rectImg.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(20).heightEqualToWidth();
        
        [self.contentView addSubview:self.avatarImgView];
        self.avatarImgView.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, MARGIN_20).widthIs(40).heightEqualToWidth();
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.avatarImgView, 14).rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, MARGIN_20).heightIs(16);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftEqualToView(self.titleLabel).topSpaceToView(self.titleLabel, 8).rightSpaceToView(self.contentView, MARGIN_20).heightIs(15);
        self.bottomLineView.backgroundColor = HEX_RGB_Alpha(0xEEEEEE, 0.15);
        [self setupAutoHeightWithBottomView:self.avatarImgView bottomMargin:MARGIN_20];
    }
    return self;
}

-(void)setModel:(BPCandidateModel *)model{
    [self.avatarImgView sd_setImageWithURL:String_To_URL(model.logo_256) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.titleLabel.text = model.owner;
    self.detailLabel.text = [NSString stringWithFormat:@"%.2f%@", model.total_votes.doubleValue/ 1000000000000, NSLocalizedString(@"亿票", nil)];
    if (model.isSelected) {
        self.rectImg.image = [UIImage imageNamed:@"rectangle_selected"];
    }else{
        self.rectImg.image = [UIImage imageNamed:@"rectangle_UnSelected"];
    }
    
}

- (void)avatarImageTap{
    if (IsNilOrNull(self.onAvatarViewClick)) {
        return;
    }
    self.onAvatarViewClick();
}

@end
