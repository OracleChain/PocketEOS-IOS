//
//  ApplicationHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ApplicationHeaderView.h"
#import "SDCycleScrollView.h"
#import "ApplicationMainHeaderBottomView.h"


@interface ApplicationHeaderView()<SDCycleScrollViewDelegate>

@end


@implementation ApplicationHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)updateViewWithModel:(ApplicationHeaderViewModel *)model{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4) delegate:self placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    cycleScrollView.imageURLStringsGroup = model.imageURLStringsGroup;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:cycleScrollView];
    
    if (model.top4DataArray.count > 0) {
        UIView *top4BaseView = [[UIView alloc] init];
        top4BaseView.backgroundColor = [UIColor redColor];
        top4BaseView.frame = CGRectMake(0, SCREEN_WIDTH * 0.4, SCREEN_WIDTH, 104);
        [self addSubview:top4BaseView];
    }
    
    ApplicationMainHeaderBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ApplicationMainHeaderBottomView" owner:nil options:nil] firstObject];
    bottomView.frame = CGRectMake(0, SCREEN_WIDTH * 0.4+104, SCREEN_WIDTH, 206);
    bottomView.backgroundColor = [UIColor yellowColor];
    [bottomView updateStarViewWithModel:nil];
    [self addSubview:bottomView];
    
}
@end
