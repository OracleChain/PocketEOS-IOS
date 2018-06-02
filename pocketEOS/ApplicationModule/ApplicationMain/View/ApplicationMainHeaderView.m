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

@property (weak, nonatomic) IBOutlet BaseSlimLineView *line1;
@property (weak, nonatomic) IBOutlet BaseView *starLabelBaseView;
@property (weak, nonatomic) IBOutlet BaseView *starDappBaseView;
@property (weak, nonatomic) IBOutlet BaseSlimLineView *line2;
@property (weak, nonatomic) IBOutlet BaseView *line3;
@property (weak, nonatomic) IBOutlet BaseView *enterpriseBaseView;


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
        [self sd_clearAutoLayoutSettings];
        self.cycleScrollView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(SCREEN_WIDTH * 0.4);
        self.line1.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.cycleScrollView, 0).heightIs(10);
        self.starLabelBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.line1, 0).heightIs(50);
        self.starDappBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.starLabelBaseView, 0).heightIs(86);
        self.line2.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.starDappBaseView, 0).heightIs(10);
        self.enterpriseBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.line2, 0).heightIs(50);
        self.line3.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.enterpriseBaseView, 0).heightIs(0.5);
        [self setupAutoHeightWithBottomView:self.line3 bottomMargin:20];
        [self setNeedsDisplay];
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
    self.starTitleLabel.text = [NSString stringWithFormat:@" %@", model.applyName];
    self.starDetailView.text = model.applyDetails;
}

@end
