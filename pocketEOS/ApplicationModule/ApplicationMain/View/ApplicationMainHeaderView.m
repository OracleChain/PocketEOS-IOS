//
//  ApplicationMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/14.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ApplicationMainHeaderView.h"
#import "UIButton+WebCache.h"
#import "Enterprise.h"
#import "Application.h"

@interface ApplicationMainHeaderView()


/**
 展示的四个
 */
@property (weak, nonatomic) IBOutlet UIView *top4BackgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *starImg;
@property (weak, nonatomic) IBOutlet UILabel *starTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *starDetailView;

@end

@implementation ApplicationMainHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.starImg.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.starDetailView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    self.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    
}

- (void)updateViewWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    CGFloat itemWidth_height = 45;
    CGFloat item_margin = (SCREEN_WIDTH - (itemWidth_height * array.count)) / 5;
    for (int i = 0 ; i < array.count ; i ++) {
        Enterprise *model = array[i];
        UIImageView *img = [[UIImageView alloc] init];
        [img sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.enterpriseIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        img.sd_cornerRadius = @(itemWidth_height / 2);
        img.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, 20, itemWidth_height, itemWidth_height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop4ImgView:)];
        [img addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.enterpriseName;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        
        label.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, 65, itemWidth_height, itemWidth_height);
        [self.top4BackgroundView addSubview:img];
        [self.top4BackgroundView addSubview:label];
    }
}

- (void)tapTop4ImgView:(UIGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(top4ImgViewDidClick:)]) {
        [self.delegate top4ImgViewDidClick: sender];
    }
}

- (IBAction)starApplicationBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(starApplicationBtnDidClick:)]) {
        [self.delegate starApplicationBtnDidClick:sender];
    }
}

- (void)updateStarViewWithModel:(Application *)model{
    [self.starImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.applyIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.starTitleLabel.text = model.applyName;
    self.starDetailView.text = model.applyDetails;
    
//    self.starImg.sd_cornerRadius = @10;
}
@end
