//
//  SuspendCenterPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNSuspendCenterPageVC.h"
#import "SDCycleScrollView.h"
#import "NewsListViewController.h"
#import "NewsMainHeaderView.h"
#import "NewsBannerService.h"
#import "News.h"
#import "NewsDetailViewController.h"

@interface YNSuspendCenterPageVC () <YNPageViewControllerDataSource, YNPageViewControllerDelegate, SDCycleScrollViewDelegate, NewsMainHeaderViewDelegate>

@property (nonatomic, copy) NSArray *imagesURLs;
@property(nonatomic, strong) NewsMainHeaderView *newsMainHeaderView;
@property(nonatomic, strong) NewsBannerService *bannerService;
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation YNSuspendCenterPageVC

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:NSLocalizedString(@"新闻", nil)rightBtnImgName:@"" delegate:nil];
    }
    return _navView;
}


- (NewsMainHeaderView *)newsMainHeaderView{
    if (!_newsMainHeaderView) {
        _newsMainHeaderView = [[NewsMainHeaderView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, CYCLESCROLLVIEW_HEIGHT + 48))];
        _newsMainHeaderView.delegate = self;
        _newsMainHeaderView.scrollView.delegate = self;
    }
    return _newsMainHeaderView;
}
- (NewsBannerService *)bannerService{
    if (!_bannerService) {
        _bannerService = [[NewsBannerService alloc] init];
    }
    return _bannerService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = nil;
    [self.view addSubview:self.navView];
    [self requestNewsBanner];
}

/**
 请求轮播图数据
 */
- (void)requestNewsBanner{
    WS(weakSelf);
    [self.bannerService buildDataSource:^(id service, BOOL isSuccess) {
        if (weakSelf.bannerService.imageURLStringsGroup.count > 0) {
            weakSelf.newsMainHeaderView.scrollView.imageURLStringsGroup = weakSelf.bannerService.imageURLStringsGroup;
            
        }
        
    }];
}

+ (instancetype)suspendCenterPageVC {
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    
    YNSuspendCenterPageVC *vc = [YNSuspendCenterPageVC pageViewControllerWithControllers:[self getArrayVCs] titles:[self getArrayTitles] config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) imageURLStringsGroup:vc.imagesURLs];
    autoScrollView.delegate = vc;
    
    vc.headerView = autoScrollView;
//    vc.headerView = vc.newsMainHeaderView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    return vc;
}



+ (NSArray *)getArrayVCs {
    
    NewsListViewController *vc_1 = [[NewsListViewController alloc] init];
    vc_1.title = @"鞋子";
    
    NewsListViewController *vc_2 = [[NewsListViewController alloc] init];
    vc_2.title = @"衣服";
    
    NewsListViewController *vc_3 = [[NewsListViewController alloc] init];
    vc_3.title = @"衣服";
    return @[vc_1, vc_2, vc_3];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}


#pragma mark - Getter and Setter
- (NSArray *)imagesURLs {
    if (!_imagesURLs) {
        _imagesURLs = @[
                        @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                        @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    }
    return _imagesURLs;
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[NewsListViewController class]]) {
        return [(NewsListViewController *)vc mainTableView];
    }
    else {
        return [(NewsListViewController *)vc mainTableView];
        
    }
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
//        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerService.dataSourceArray.count > 0) {
        
        News *news = (News *)self.bannerService.dataSourceArray[index];
        if (news) {
            NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
            if ([news.newsUrl hasPrefix: @"http"]) {
                vc.urlStr = news.newsUrl;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [TOASTVIEW showWithText:NSLocalizedString(@"新闻地址有误!", nil)];
            }
        }
    }
}

@end
