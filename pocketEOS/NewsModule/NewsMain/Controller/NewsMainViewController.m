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
#import "PopUpWindow.h"
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

@interface NewsMainViewController ()<UIGestureRecognizerDelegate, SDCycleScrollViewDelegate , UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, NewsMainHeaderViewDelegate, PopUpWindowDelegate>
@property(nonatomic, strong) NewsMainHeaderView *newsMainHeaderView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
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
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:@"新闻" rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}


- (PopUpWindow *)popUpWindow{
    if (!_popUpWindow) {
        _popUpWindow = [[PopUpWindow alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT + SCREEN_WIDTH *0.4 + 48, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SCREEN_WIDTH *0.4 - 48 ))];
        _popUpWindow.delegate = self;
    }
    return _popUpWindow;
}

- (NewsMainHeaderView *)newsMainHeaderView{
    if (!_newsMainHeaderView) {
        _newsMainHeaderView = [[NewsMainHeaderView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH *0.4 + 48))];
        _newsMainHeaderView.delegate = self;
        _newsMainHeaderView.scrollView.delegate = self;
    }
    return _newsMainHeaderView;
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
    
    [self loadAllBlocks];
    [self.mainTableView.mj_header beginRefreshing];
    [self requestNewsBanner];
    
    WS(weakSelf);
    [self.mainService GetAssetCategoryAllRequest:^(NSMutableArray *assestsArray, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.allAssetsArray = assestsArray;
        }
    }];
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
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

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.popUpWindow setOnBottomViewDidClick:^{
        [weakSelf removePopUpWindow];
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
        [TOASTVIEW showWithText:@"新闻地址有误!"];
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
                [TOASTVIEW showWithText:@"新闻地址有误!"];
            }
        }
    }
}

// NewsMainHeaderViewDelegate
- (void)currentAssestsLabelDidTap:(UITapGestureRecognizer *)sender{
    [self.view addSubview:self.popUpWindow];
    
    UIView *a = [(BaseTabBarController *)self.parentViewController.parentViewController view];
    [a sendSubviewToBack:[(BaseTabBarController *)self.parentViewController.parentViewController tabBar]];
    self.popUpWindow.type = PopUpWindowTypeAssest;
    if (IsStrEmpty(self.selectAssests) && (self.allAssetsArray.count > 0)) {
        Assest *model = self.allAssetsArray[0];
        model.selected = YES;
    }else{
        for (Assest *model in self.allAssetsArray) {
            if ([model.assetName isEqualToString:self.selectAssests]) {
                model.selected = YES;
            }else{
                model.selected = NO;
            }
        }
    }
    [self.popUpWindow updateViewWithArray:self.allAssetsArray title:@""];
}

// PopUpWindowDelegate
-(void)popUpWindowdidSelectItem:(id )sender{
    Assest *assest = sender;
    self.selectAssests = assest.assetName;
    self.newsMainHeaderView.currentAssestsLabel.text = [NSString stringWithFormat:@"%@", self.selectAssests];
    self.mainService.newsRequest.assetCategoryId = assest.ID;
    [self removePopUpWindow];
    [self loadNewData];
}

- (void)removePopUpWindow{
    [self.popUpWindow removeFromSuperview];
    UIView *a = [(BaseTabBarController *)self.parentViewController.parentViewController view];
    [a bringSubviewToFront:[(BaseTabBarController *)self.parentViewController.parentViewController tabBar]];
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
