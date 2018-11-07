//
//  ApplicationCollectionViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ApplicationCollectionViewCell.h"
#import "Application.h"


@implementation ApplicationCollectionViewCell

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.sd_cornerRadius = @12;
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

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x999999);
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descriptionLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self.contentView addSubview:self.img];
        
        self.img.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, MARGIN_15).widthIs(45).heightIs(45);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_img, 10 ).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 21).heightIs(15);
        
        [self.contentView addSubview:self.descriptionLabel];
        self.descriptionLabel.sd_layout.leftSpaceToView(_img, 10).topSpaceToView(_titleLabel, 6).rightSpaceToView(self.contentView, MARGIN_20).autoHeightRatio(0);
        
        [self.bottomLineView sd_clearAutoLayoutSettings];
        self.bottomLineView.sd_layout.leftSpaceToView(self.contentView, 74).topSpaceToView(self.descriptionLabel, MARGIN_20).rightSpaceToView(self.contentView, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:0];
        
    }
    return self;
}


//-(void)setModel:(Application *)model{
//    [_img sd_setImageWithURL: String_To_URL(VALIDATE_STRING(model.applyIcon) )  placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
//    _titleLabel.text = model.applyName;
//    _descriptionLabel.text = model.applyDetails;
//}

- (void)setModel:(DappModel *)model{
    [_img sd_setImageWithURL: String_To_URL(VALIDATE_STRING(model.dappIcon) )  placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    _titleLabel.text = model.dappName;
    _descriptionLabel.text = model.dappIntro;
}

@end
