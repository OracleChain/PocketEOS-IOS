//
//  BaseTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 17/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (UIImageView *)rightIconImageView{
    if (!_rightIconImageView) {
        _rightIconImageView = [[UIImageView alloc] init];
//        _rightArrowImg.backgroundColor= [UIColor whiteColor];
        _rightIconImageView.image = [UIImage imageNamed:self.rightIconImgName];
//
    }
    return _rightIconImageView;
}
- (BaseSlimLineView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[BaseSlimLineView alloc] init];
    }
    return _bottomLineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.contentView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        self.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
        
        [self.contentView addSubview:self.bottomLineView];
        self.bottomLineView.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(DEFAULT_LINE_HEIGHT);
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
    
    [self.contentView addSubview:self.bottomLineView];
    self.bottomLineView.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
}

@end
