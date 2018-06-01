//
//  CandyMainTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CandyMainTableViewCell.h"

@interface CandyMainTableViewCell()
@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic , strong) UIButton *btn;
@end


@implementation CandyMainTableViewCell

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _img;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = HEXCOLOR(0x2A2A2A);
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x999999);
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _descriptionLabel;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        _btn.sd_cornerRadius = @4;
        [_btn setTitleColor:HEXCOLOR(0xC7C7C7) forState:(UIControlStateNormal)];
        _btn.layer.borderWidth = 1;
        _btn.layer.borderColor = HEXCOLOR(0xC7C7C7).CGColor;
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _btn;
}
- (BaseSlimLineView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[BaseSlimLineView alloc] init];
    }
    return _bottomLineView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self.contentView addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 23.5).widthIs(26).heightIs(26);
        
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(_img, 10 ).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 17.5).heightIs(18);
        
        [self.contentView addSubview:self.descriptionLabel];
        self.descriptionLabel.sd_layout.leftSpaceToView(_img, 10).topSpaceToView(_titleLabel, 4).rightSpaceToView(self.contentView, 20).heightIs(17);
        
        [self.contentView addSubview:self.btn];
        self.btn.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).heightIs(30).widthIs(68);
        
        [self.contentView addSubview:self.bottomLineView];
        self.bottomLineView.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    }
    return self;
}

-(void)setModel:(CandyTaskModel *)model{
    [self.img sd_setImageWithURL:String_To_URL(model.avatar) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.titleLabel.text = model.title;
    self.descriptionLabel.text = model.task_description;
    if (model.completed) {
        [self.btn setTitle:@"已完成" forState:(UIControlStateNormal)];
    }else{
        [self.btn setTitle:@"未完成" forState:(UIControlStateNormal)];
    }
}

@end
