//
//  DiscoverMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define DISCOVER_BANNER_HEIGHT DISCOVER_CYCLESCROLLVIEW_HEIGHT + MARGIN_20 + MARGIN_15 + 18 + 8 + 13 + 10
#import "DiscoverMainHeaderView.h"
#import "TYCyclePagerView.h"
#import "DiscoverBannerCollectionViewCell.h"

@interface DiscoverMainHeaderView ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) NSArray *datas;

@property(nonatomic , strong) UIView *recommendDappsBaseView;

@property(nonatomic , strong) UIView *starDappBaseView;

@end

@implementation DiscoverMainHeaderView

- (UIView *)recommendDappsBaseView{
    if (!_recommendDappsBaseView) {
        _recommendDappsBaseView = [[UIView alloc] init];
    }
    return _recommendDappsBaseView;
}

- (UIView *)starDappBaseView{
    if (!_starDappBaseView) {
        _starDappBaseView = [[UIView alloc] init];
    }
    return _starDappBaseView;
}

- (ScrollMenuView *)scrollMenuView{
    if (!_scrollMenuView) {
        _scrollMenuView = [[ScrollMenuView alloc] init];
    }
    return _scrollMenuView;
}




- (void)updateViewWithModel:(Get_recommend_dapp_result *)model{
    self.model = model;
    [self addPagerView];
    [self loadData];
    
    [self addRecommendDappsView];
    [self addStarDappView];
    [self addScrollMenuView];
    
    self.recommendDappsBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT, SCREEN_WIDTH, RECOMMEN_Dapps_BaseVIEW_HEIGHT);
    self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT, SCREEN_WIDTH, STAR_Dapp_BaseVIEW_HEIGHT);
    self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT + STAR_Dapp_BaseVIEW_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
    
    if (model.introDapps.count == 0) {
        
        self.recommendDappsBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT, SCREEN_WIDTH, 0);

        if (model.starDapps.count > 0) {
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0, SCREEN_WIDTH, STAR_Dapp_BaseVIEW_HEIGHT);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0 + STAR_Dapp_BaseVIEW_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }else{
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0, SCREEN_WIDTH, 0);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0 + 0, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }


    }else if (model.introDapps.count > 0 && model.introDapps.count <= 4){
        self.recommendDappsBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT, SCREEN_WIDTH, RECOMMEN_Dapps_BaseVIEW_HEIGHT/2);
        
        if (model.starDapps.count > 0) {
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT/2, SCREEN_WIDTH, STAR_Dapp_BaseVIEW_HEIGHT);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT/2 + STAR_Dapp_BaseVIEW_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }else{
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0, SCREEN_WIDTH, 0);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT/2 + 0, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }

        
        

    }else if (model.introDapps.count > 4 ){
        self.recommendDappsBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT, SCREEN_WIDTH, RECOMMEN_Dapps_BaseVIEW_HEIGHT);
        
        if (model.starDapps.count > 0) {
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT, SCREEN_WIDTH, STAR_Dapp_BaseVIEW_HEIGHT);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT + STAR_Dapp_BaseVIEW_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }else{
            self.starDappBaseView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + 0, SCREEN_WIDTH, 0);
            self.scrollMenuView.frame = CGRectMake(0, DISCOVER_BANNER_HEIGHT + RECOMMEN_Dapps_BaseVIEW_HEIGHT + 0, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        }
        
        

    }

    
    
    
    
}

#pragma mark - scrollMenuView
- (void)addScrollMenuView{
    [self addSubview:self.scrollMenuView];
}

#pragma mark - starDappView
- (void)addStarDappView{
    [self addSubview:self.starDappBaseView];
//    self.starDappBaseView.backgroundColor = [UIColor whiteColor];
    self.starDappBaseView.userInteractionEnabled = YES;
    
    
    if (!(self.model.starDapps.count > 0)) {
        return;
    }
    DappModel *model = self.model.starDapps[0];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView sd_setImageWithURL:String_To_URL(model.dappPicture) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    
    [self.starDappBaseView addSubview:imageView];
    imageView.sd_layout.leftSpaceToView(self.starDappBaseView, 30).rightSpaceToView(self.starDappBaseView, 20).topSpaceToView(self.starDappBaseView, 0).bottomSpaceToView(self.starDappBaseView, 30);
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starDappImageViewDidTap)];
    [imageView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = HEXCOLOR(0xFAFAFA);
    [self.starDappBaseView addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.starDappBaseView, 0).rightSpaceToView(self.starDappBaseView, 0).bottomSpaceToView(self.starDappBaseView, 0).heightIs(MARGIN_10);
    
}


- (void)starDappImageViewDidTap{
    if (!(self.model.starDapps.count > 0)) {
        return;
    }
    DappModel *model =  self.model.starDapps[0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoverMainHeaderViewDappItemDidClick:)]) {
        [self.delegate discoverMainHeaderViewDappItemDidClick:model];
    }
}



#pragma mark - recommendDapps
- (void)addRecommendDappsView{
    [self addSubview:self.recommendDappsBaseView];
//    self.recommendDappsBaseView.backgroundColor = RandomColor;
    
    
    NSArray *recommendDappsModelArray = self.model.introDapps;
    CGFloat itemWidth_height = 45;
    CGFloat item_margin = (SCREEN_WIDTH - (itemWidth_height * 4)) / 5;
    for (int i = 0 ; i < recommendDappsModelArray.count ; i ++) {
        DappModel *model = recommendDappsModelArray[i];
        UIImageView *img = [[UIImageView alloc] init];
        [img sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.dappIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
        img.tag = 1000 + i;
        img.layer.cornerRadius = 12;
        img.layer.masksToBounds = YES;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecommendDappImgView:)];
        [img addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.dappName;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        
        [self.recommendDappsBaseView addSubview:img];
        [self.recommendDappsBaseView addSubview:label];
        
        if (i < 4) {
            img.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, 20, itemWidth_height, itemWidth_height);
            label.sd_layout.centerXEqualToView(img).topSpaceToView(img, MARGIN_10).heightIs(13);
            [label setSingleLineAutoResizeWithMaxWidth:120];
            
        }else if (i >= 4 && i < 8 ){
            img.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*(i-4), 20 + 100, itemWidth_height, itemWidth_height);
            label.sd_layout.centerXEqualToView(img).topSpaceToView(img, MARGIN_10).heightIs(13);
            [label setSingleLineAutoResizeWithMaxWidth:80];
        }
        
        
    }
    
    
    
}

    
- (void)tapRecommendDappImgView:(UIGestureRecognizer *)sender{
    DappModel *model =  self.model.introDapps[sender.view.tag - 1000];
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoverMainHeaderViewDappItemDidClick:)]) {
        [self.delegate discoverMainHeaderViewDappItemDidClick:model];
    }
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
    [pagerView registerClass:[DiscoverBannerCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self addSubview:pagerView];
    _pagerView = pagerView;
    _pagerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, DISCOVER_BANNER_HEIGHT);
}

- (void)loadData {
    _datas = self.model.bannerDapps;
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
}


#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _datas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DiscoverBannerCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    DappModel *model = _datas[index];
    cell.model = model;
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
    DappModel *model = _datas[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoverMainHeaderViewDappItemDidClick:)]) {
        [self.delegate discoverMainHeaderViewDappItemDidClick:model];
    }
}

@end
