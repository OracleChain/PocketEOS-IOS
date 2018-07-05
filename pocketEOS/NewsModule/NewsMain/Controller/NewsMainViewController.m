//
//  NewsMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "NewsMainViewController.h"
#import "SideBarViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "SDCycleScrollView.h"
#import "NavigationView.h"
#import "NewsService.h"
#import "News.h"
#import "NewsListCell.h"
#import "NewsMainHeaderView.h"
#import "NewsBannerService.h"
#import "NewsDetailViewController.h"
#import "Assest.h"
#import "NewsResult.h"
#import "BaseTabBarController.h"
#import "ScrollMenuView.h"


@interface NewsMainViewController ()<UIGestureRecognizerDelegate, SDCycleScrollViewDelegate , UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, NewsMainHeaderViewDelegate, ScrollMenuViewDelegate>
@property(nonatomic, strong) NewsMainHeaderView *newsMainHeaderView;
@property(nonatomic , strong) ScrollMenuView *scrollMenuView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) NewsService *mainService;
@property(nonatomic, strong) NewsBannerService *bannerService;
/**
 选中的资产.
 */
@property(nonatomic, strong) NSString *selectAssests;
@property(nonatomic, strong) NSMutableArray *allAssetsArray;
@end

@implementation NewsMainViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:NSLocalizedString(@"新闻", nil)rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}

- (NewsMainHeaderView *)newsMainHeaderView{
    if (!_newsMainHeaderView) {
        _newsMainHeaderView = [[NewsMainHeaderView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, CYCLESCROLLVIEW_HEIGHT + 48))];
        _newsMainHeaderView.delegate = self;
        _newsMainHeaderView.scrollView.delegate = self;
        _newsMainHeaderView.scrollMenuView.delegate = self;
    }
    return _newsMainHeaderView;
}

- (ScrollMenuView *)scrollMenuView{
    if (!_scrollMenuView) {
        _scrollMenuView = [[ScrollMenuView alloc] init];
        _scrollMenuView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT);
        _scrollMenuView.delegate = self;
        _scrollMenuView.hidden = YES;
    }
    return _scrollMenuView;
}



- (NewsService *)mainService{
    if (!_mainService) {
        _mainService = [[NewsService alloc] init];
    }
    return _mainService;
}
- (NewsBannerService *)bannerService{
    if (!_bannerService) {
        _bannerService = [[NewsBannerService alloc] init];
    }
    return _bannerService;
}
- (NSMutableArray *)allAssetsArray{
    if (!_allAssetsArray) {
        _allAssetsArray = [[NSMutableArray alloc] init];
    }
    return _allAssetsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view..
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    [self.mainTableView setTableHeaderView:self.newsMainHeaderView];
    [self.view addSubview:self.scrollMenuView];
    
    [self.mainTableView.mj_header beginRefreshing];
    [self requestNewsBanner];
    [self requestAllAssetCategory];
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
}

- (void)requestAllAssetCategory{
    WS(weakSelf);
    [self.mainService GetAssetCategoryAllRequest:^(NSMutableArray *assestsArray, BOOL isSuccess) {
        if (isSuccess) {
            if (assestsArray.count > 0) {
                weakSelf.allAssetsArray = assestsArray;
                [weakSelf.newsMainHeaderView.scrollMenuView updateViewWithAssestsArray:assestsArray];
                [weakSelf.scrollMenuView updateViewWithAssestsArray:assestsArray];
                
                
            }
        }
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    News *news = (News *)self.mainService.dataSourceArray[indexPath.row];
    cell.model = news;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    News *news = (News *)self.mainService.dataSourceArray[indexPath.row];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
    if ([news.newsUrl hasPrefix: @"http"]) {
        vc.urlStr = news.newsUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"链接地址有误!", nil)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

#pragma mark - 侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    [self profileCenter];
}

- (void)profileCenter{
    // 自己随心所欲创建的一个控制器
    SideBarViewController *vc = [[SideBarViewController alloc] init];;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    // 调用这个方法
    [self cw_showDrawerViewController:navi animationType:CWDrawerAnimationTypeMask configuration:nil];
}

// 轮播图的点击回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
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

//ScrollMenuViewDelegate
- (void)menuScrollViewItemBtnDidClick:(UIButton *)sender{
    Assest *assest = self.allAssetsArray[sender.tag-1000];
    self.selectAssests = assest.assetName;
    self.mainService.newsRequest.assetCategoryId = assest.ID;
    [self loadNewData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%.6f", scrollView.contentOffset.y);
    WS(weakSelf);
    if (scrollView.contentOffset.y > CYCLESCROLLVIEW_HEIGHT) {
        [UIView animateWithDuration:1 animations:^{
            weakSelf.scrollMenuView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            weakSelf.scrollMenuView.hidden = YES;
        }];
    }
}

#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    [self.mainTableView.mj_footer resetNoMoreData];
    [self.mainService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        [weakSelf.mainTableView reloadData];
        if (isSuccess) {
            // 刷新表格
            if ([dataCount isEqualToNumber:@0]) {
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshing];
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    WS(weakSelf);
    
    [self.mainService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
        }
    }];
}
@end

