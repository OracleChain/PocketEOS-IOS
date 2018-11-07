//
//  NewsMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//



#import "NewsMainHeaderView.h"
#import "TYCyclePagerView.h"
#import "TYCyclePagerViewCell.h"

@interface NewsMainHeaderView()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) NSMutableArray *datas;
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
//        [self addSubview:self.scrollView];
        [self addPagerView];
        [self addSubview:self.scrollMenuView];
    }
    return self;
}


- (void)updateBannerViewWithModelArr:(NSArray *)arr{
    
    self.datas = [NSMutableArray arrayWithArray:arr];
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
}

#pragma mark - TYCyclePagerView
- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    //    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self addSubview:pagerView];
    _pagerView = pagerView;
    _pagerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CYCLESCROLLVIEW_HEIGHT);
}


#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _datas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    
    News *model = self.datas[index];
    [cell.imageView sd_setImageWithURL:String_To_URL(model.imageUrl) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    
    
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.85, CGRectGetHeight(pageView.frame)*0.85);
    layout.itemSpacing = 18;
    //layout.minimumAlpha = 0.3;
    //    layout.itemHorizontalCenter = _horCenterSwitch.isOn;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    //[_pageControl setCurrentPage:newIndex animate:YES];
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

/**
 pagerView did selected item cell
 */
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    
    News *model = self.datas[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsMainHeaderViewBannerImageViewDidSelect:)]) {
        [self.delegate newsMainHeaderViewBannerImageViewDidSelect:model];
    }
}

@end
