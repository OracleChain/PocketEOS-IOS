//
//  NewsMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//



#import "NewsMainHeaderView.h"


@interface NewsMainHeaderView()
@end


@implementation NewsMainHeaderView


- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CYCLESCROLLVIEW_HEIGHT) delegate:nil placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _scrollView;
}
- (ScrollMenuView *)scrollMenuView{
    if (!_scrollMenuView) {
        _scrollMenuView = [[ScrollMenuView alloc] init];
        _scrollMenuView.frame = CGRectMake(0, CYCLESCROLLVIEW_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
    }
    return _scrollMenuView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.scrollMenuView];
    }
    return self;
}
@end
