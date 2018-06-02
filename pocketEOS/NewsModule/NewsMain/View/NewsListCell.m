//
//  NewsListCell.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "NewsListCell.h"

@interface NewsListCell()

// 标题
@property(nonatomic, strong) BaseLabel *titleLabel;
// 概要
@property(nonatomic, strong) UILabel *summaryLable;

@property(nonatomic, strong) UIImageView *photoImg;
@property(nonatomic, strong) UIImageView *timeImg;
@property(nonatomic, strong) UILabel *timeLabel;

@end



@implementation NewsListCell

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)summaryLable{
    if (!_summaryLable) {
        _summaryLable = [[UILabel alloc] init];
        _summaryLable.textColor = HEXCOLOR(0x999999 );
        _summaryLable.font = [UIFont systemFontOfSize:14];
    }
    return _summaryLable;
}
- (UIImageView *)photoImg{
    if (!_photoImg) {
        _photoImg = [[UIImageView alloc] init];
        _photoImg.sd_cornerRadius = @4;
    }
    return _photoImg;
}
- (UIImageView *)timeImg{
    if (!_timeImg) {
        _timeImg = [[UIImageView alloc] init];
        _timeImg.image = [UIImage imageNamed:@"news_list_cell_time"];
    }
    return _timeImg;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0xDDDDDD );
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        
        [self.contentView addSubview:self.photoImg];
        self.photoImg.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(80).heightEqualToWidth();

        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, MARGIN_15+2).widthIs(SCREEN_WIDTH - _photoImg.width - (MARGIN_20 * 3)).heightIs(44);
        
//        [self.contentView addSubview:self.summaryLable];
//        self.summaryLable.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(_titleLabel, 4).widthIs(SCREEN_WIDTH - _photoImg.width - (MARGIN_20 * 3)).heightIs(17);

        [self.contentView addSubview:self.timeImg];
        self.timeImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).bottomSpaceToView(self.contentView, 18).widthIs(12).heightEqualToWidth();

        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.sd_layout.leftSpaceToView(_timeImg, 4).centerYEqualToView(_timeImg).heightIs(18).rightSpaceToView(_photoImg, MARGIN_20);
        

    }
    return self;
}

-(void)setModel:(News *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.summaryLable.text = model.summary;
    [self.photoImg sd_setImageWithURL:String_To_URL(model.imageUrl) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.timeLabel.text = model.createTime;
}
@end
