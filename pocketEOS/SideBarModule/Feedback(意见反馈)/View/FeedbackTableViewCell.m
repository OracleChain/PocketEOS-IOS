//
//  FeedbackTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/17.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "FeedbackTableViewCell.h"

@interface FeedbackTableViewCell()

/**
 图标
 */
@property(nonatomic, strong) UIImageView *img;

@property(nonatomic, strong) UIView *lineView;
// 概要
@property(nonatomic, strong) UILabel *summaryLable;
@end


@implementation FeedbackTableViewCell

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"feedBackAsk"];
    }
    return _img;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _lineView;
}

- (UILabel *)summaryLable{
    if (!_summaryLable) {
        _summaryLable = [[UILabel alloc] init];
        _summaryLable.textColor = HEXCOLOR(0x999999 );
        _summaryLable.font = [UIFont systemFontOfSize:13];
        
    }
    return _summaryLable;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 17).widthIs(20).heightIs(18);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.img, 8).topSpaceToView(self.contentView, MARGIN_15).rightSpaceToView(self.contentView, MARGIN_20).autoHeightRatio(0);
        
        [self.contentView addSubview:self.lineView];
        self.lineView.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.titleLabel, MARGIN_15).rightSpaceToView(self.contentView, 0).heightIs(0.5);
        
        [self.contentView addSubview:self.summaryLable];
        self.summaryLable.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(_lineView, MARGIN_15).rightSpaceToView(self.contentView, MARGIN_20).autoHeightRatio(0);
      
        [self setupAutoHeightWithBottomView:self.summaryLable bottomMargin:MARGIN_15];
    }
    return self;
}

-(void)setModel:(MessageFeedback *)model{
    _model = model;
    self.titleLabel.text = model.content;
    self.summaryLable.text = model.comment;
}

@end
