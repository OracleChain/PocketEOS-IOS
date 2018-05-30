//
//  MessageCenterTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@interface MessageCenterTableViewCell()

// 标题
@property(nonatomic, strong) UILabel *titleLabel;
// 概要
@property(nonatomic, strong) UILabel *summaryLable;
// 时间
@property(nonatomic, strong) UILabel *timeLabel;


@end


@implementation MessageCenterTableViewCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)summaryLable{
    if (!_summaryLable) {
        _summaryLable = [[UILabel alloc] init];
        _summaryLable.textColor = HEXCOLOR(0x999999 );
        _summaryLable.font = [UIFont systemFontOfSize:13];
       
    }
    return _summaryLable;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999 );
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        self.contentView.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self, 10).bottomSpaceToView(self, 0).topSpaceToView(self, 10);

        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_15).topSpaceToView(self.contentView, MARGIN_15).rightSpaceToView(self.timeLabel, 10).heightIs(21);
        
        [self.contentView addSubview:self.summaryLable];
        self.summaryLable.sd_layout.leftSpaceToView(self.contentView, MARGIN_15).topSpaceToView(_titleLabel, 14).rightSpaceToView(self.contentView, MARGIN_15).autoHeightRatio(0);
        
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_15).centerYEqualToView(_titleLabel).widthIs(50).heightIs(17);
        
        [self setupAutoHeightWithBottomView:self.summaryLable bottomMargin:30];
    }
    return self;
}

-(void)setModel:(MessageCenter *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.summaryLable.text = model.summary;
    self.timeLabel.text = model.createTime;
    
}
@end
