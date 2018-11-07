//
//  DiscoverMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DiscoverMainViewController.h"
#import "DiscoverMainHeaderView.h"
#import "DiscoverService.h"
#import "Get_recommend_dapp_result.h"
#import "ScrollMenuView.h"
#import "Discover_Category_config_result.h"
#import "Discover_Category_config_model.h"
#import "ApplicationCollectionViewCell.h"
#import "QuestionListViewController.h"
#import "DAppDetailViewController.h"
#import "CommonDialogHasTitleView.h"

@interface DiscoverMainViewController ()<ScrollMenuViewDelegate, DiscoverMainHeaderViewDelegate, CommonDialogHasTitleViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) DiscoverMainHeaderView *headerView;
@property(nonatomic , strong) DiscoverService *mainService;
@property(nonatomic , strong) ScrollMenuView *scrollMenuView;
@property(nonatomic , strong) CommonDialogHasTitleView *commonDialogHasTitleView;
@property(nonatomic , strong) DappModel *currentDappModel;
@property(nonatomic , assign) double discoverHeaderViewHeight;

@end

@implementation DiscoverMainViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:NSLocalizedString(@"发现", nil)rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}

- (DiscoverMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DiscoverMainHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.scrollMenuView.delegate = self;
        _headerView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, _discoverHeaderViewHeight);
    }
    return _headerView;
}

- (DiscoverService *)mainService{
    if (!_mainService) {
        _mainService = [[DiscoverService alloc] init];
    }
    return _mainService;
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

- (CommonDialogHasTitleView *)commonDialogHasTitleView{
    if (!_commonDialogHasTitleView) {
        _commonDialogHasTitleView = [[CommonDialogHasTitleView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _commonDialogHasTitleView.delegate = self;
    }
    return _commonDialogHasTitleView;
}

// 隐藏自带的导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_footer.hidden = YES;
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    
    [self.view addSubview:self.scrollMenuView];
    [self requestRecommend_dapp];
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplicationCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[ApplicationCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    DappModel *model = (DappModel *)self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DappModel *model = (DappModel *)self.mainService.dataSourceArray[indexPath.row];
    self.currentDappModel = model;
    [self addCommonDialogHasTitleView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DappModel *model = (DappModel *)self.mainService.dataSourceArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ApplicationCollectionViewCell class]  contentViewWidth:SCREEN_WIDTH ];
}




- (void)requestRecommend_dapp{
    WS(weakSelf);
    [self.mainService get_recommend_dapp:^(Get_recommend_dapp_result *result, BOOL isSuccess) {
        if (isSuccess) {
            
            [weakSelf calculateDiscoverHeaderViewHeight:result];
            [weakSelf.mainTableView setTableHeaderView:weakSelf.headerView];
            [weakSelf.headerView updateViewWithModel:result];
            [weakSelf requestAllDappCategory];
        }
    }];
}

- (void)requestAllDappCategory{
    WS(weakSelf);
    [self.mainService get_category_config:^(Discover_Category_config_result *result, BOOL isSuccess) {
        if (isSuccess) {
            if (result.data.count > 0) {
                
                NSMutableArray *tmpArr = [NSMutableArray array];
                for (int i = 0; i < result.data.count; i++) {
                    Discover_Category_config_model *categoryModel = result.data[i];
                    OptionModel *model = [[OptionModel alloc] init];
                    model.optionName = categoryModel.dappCategoryName;
                    [tmpArr addObject:model];
                    
                    if (i == 0) {
                        weakSelf.mainService.get_dapp_by_config_id_request.config_id = categoryModel.dappCategory_id;
                        [weakSelf loadNewData];
                        
                    }
                }
                
                [weakSelf.headerView.scrollMenuView updateViewWithOptionModelArray:tmpArr];
                [weakSelf.scrollMenuView updateViewWithOptionModelArray:tmpArr];
                
                
            }
        }
        
    }];
}

//ScrollMenuViewDelegate
- (void)menuScrollViewItemBtnDidClick:(UIButton *)sender{
    if (self.mainService.category_configDataSourceArray.count >= (sender.tag - 1000)) {
        Discover_Category_config_model *model = self.mainService.category_configDataSourceArray[sender.tag-1000];
        self.mainService.get_dapp_by_config_id_request.config_id = model.dappCategory_id;
        [self loadNewData];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    WS(weakSelf);
    if (scrollView.contentOffset.y > _discoverHeaderViewHeight) {
        [UIView animateWithDuration:1 animations:^{
            weakSelf.scrollMenuView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            weakSelf.scrollMenuView.hidden = YES;
        }];
    }
}

//DiscoverMainHeaderViewDelegate
- (void)discoverMainHeaderViewDappItemDidClick:(DappModel *)model{
      self.currentDappModel = model;
     [self addCommonDialogHasTitleView];
}


//CommonDialogHasTitleViewDelegate
- (void)commonDialogHasTitleViewConfirmBtnDidClick:(UIButton *)sender{
    if (IsNilOrNull(self.currentDappModel)) {
        return;
    }
    [self handleCommonDialogHasTitleViewConfirmBtnDidClickResult:self.currentDappModel];
}



- (void)handleCommonDialogHasTitleViewConfirmBtnDidClickResult:(DappModel *)model{
    if ([model.dappName isEqualToString:NSLocalizedString(@"有问币答", nil)]) {
        QuestionListViewController *vc = [[QuestionListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)addCommonDialogHasTitleView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.commonDialogHasTitleView];
    
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"注意", nil);
    model.detail = NSLocalizedString(@"您正在跳转至第三方Dapp,确认即同意第三方Dapp的用户协议与隐私政策，由其直接并单独向您承担责任", nil);
    [self.commonDialogHasTitleView setModel:model];
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
//- (void)loadMoreData
//{
//    WS(weakSelf);
//
//    [self.mainService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
//        if (isSuccess) {
//            // 刷新表格
//            [weakSelf.mainTableView reloadData];
//            if ([dataCount isEqualToNumber:@0]) {
//                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                // 拿到当前的下拉刷新控件，结束刷新状态
//                [weakSelf.mainTableView.mj_footer endRefreshing];
//            }
//        }else{
//            [weakSelf.mainTableView.mj_header endRefreshing];
//            [weakSelf.mainTableView.mj_footer endRefreshing];
//        }
//    }];
//}


- (void)calculateDiscoverHeaderViewHeight:(Get_recommend_dapp_result *)model{
    
    _discoverHeaderViewHeight = 0;
    if (model.bannerDapps.count > 0 ) {
        _discoverHeaderViewHeight += DISCOVER_BANNER_HEIGHT;
    }
    
    if (model.introDapps.count > 0 && model.introDapps.count <= 4) {
        _discoverHeaderViewHeight += RECOMMEN_Dapps_BaseVIEW_HEIGHT/2;
    }else if (model.introDapps.count > 4){
        _discoverHeaderViewHeight += RECOMMEN_Dapps_BaseVIEW_HEIGHT;
    }
    
    if (model.starDapps.count > 0) {
        _discoverHeaderViewHeight += STAR_Dapp_BaseVIEW_HEIGHT;
    }
    
    _discoverHeaderViewHeight += MENUSCROLLVIEW_HEIGHT;
    NSLog(@"discoverHeaderViewHeight :%.4f", _discoverHeaderViewHeight);
}
@end
