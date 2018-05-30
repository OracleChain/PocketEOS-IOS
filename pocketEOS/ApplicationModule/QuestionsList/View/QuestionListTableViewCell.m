//
//  QuestionListTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "QuestionListTableViewCell.h"
#import "Question.h"
#import "AskTitle.h"

@interface QuestionListTableViewCell()
@property(nonatomic, strong) UIImageView *avatarImg;
// 标题
@property(nonatomic, strong) UILabel *nameLabel;
// 时间
@property(nonatomic, strong) UILabel *timeLabel;
// content
@property(nonatomic, strong) UILabel *contentLable;


@end

@implementation QuestionListTableViewCell

- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.sd_cornerRadius = @10;
    }
    return _avatarImg;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x2A2A2A);
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.textColor = HEXCOLOR(0x2A2A2A );
        _contentLable.font = [UIFont systemFontOfSize:14];
    }
    return _contentLable;
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
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [self.contentView addSubview:self.avatarImg];
        self.avatarImg.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).widthIs(20).heightEqualToWidth();
        
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.sd_layout.leftSpaceToView(self.avatarImg, 10).centerYEqualToView(self.avatarImg).heightIs(21);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 200];
        
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.sd_layout.leftSpaceToView(self.nameLabel, 10).topSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, MARGIN_20).heightIs(15);

        [self.contentView addSubview:self.contentLable];
        self.contentLable.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(_avatarImg, 14).rightSpaceToView(self.contentView, MARGIN_20).autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:self.contentLable bottomMargin:16];
    }
    return self;
}

-(void)setModel:(Question *)model{
    [self.avatarImg sd_setImageWithURL: String_To_URL(VALIDATE_STRING(@"")) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    self.nameLabel.text = VALIDATE_STRING(model.from) ;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970: VALIDATE_STRING(model.createtime).integerValue] stringFormate:@"YYYY-MM-dd HH:mm:ss"];
    self.contentLable.text = VALIDATE_STRING(model.asktitle.title);
}

@end
