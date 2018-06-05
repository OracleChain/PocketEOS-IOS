//
//  ApplicationHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ApplicationHeaderView.h"
#import "ApplicationMainHeaderBottomView.h"


@interface ApplicationHeaderView()<SDCycleScrollViewDelegate,ApplicationMainHeaderBottomViewDelegate>

@end


@implementation ApplicationHeaderView

- (void)updateViewWithModel:(ApplicationHeaderViewModel *)model{
    //top4BaseView
    UIView *top4BaseView = [[UIView alloc] init];
    [self addSubview:top4BaseView];
    CGFloat itemWidth_height = 45;
    NSMutableArray *array = model.top4DataArray;
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
        [top4BaseView addSubview:img];
        [top4BaseView addSubview:label];
    }
    
    
    ApplicationMainHeaderBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ApplicationMainHeaderBottomView" owner:nil options:nil] firstObject];
    bottomView.delegate = self;
    
    if (model.starDataArray.count > 0) {
        [bottomView updateStarViewWithModel:model.starDataArray[0]];
    }
    
    if (model.top4DataArray.count > 0) {
        top4BaseView.frame = CGRectMake(0, SCREEN_WIDTH * 0.4, SCREEN_WIDTH, 104);
        bottomView.frame = CGRectMake(0, SCREEN_WIDTH * 0.4+104, SCREEN_WIDTH, 206);
    }else{
        bottomView.frame = CGRectMake(0, SCREEN_WIDTH * 0.4, SCREEN_WIDTH, 206);
    }
    [self addSubview:bottomView];
}

- (void)starApplicationBtnDidClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(starApplicationBtnDidClick:)]) {
        [self.delegate starApplicationBtnDidClick:sender];
    }
}

- (void)tapTop4ImgView:(UIGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(top4ImgViewDidClick:)]) {
        [self.delegate top4ImgViewDidClick: sender];
    }
}

@end
