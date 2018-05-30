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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.contentView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        self.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        self.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
