//
//  AddAssestsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

typedef NS_ENUM(NSInteger, AddAssestsViewControllerCurrentAction) {
    AddAssestsViewControllerActionRecommandAssests,
    AddAssestsViewControllerActionSearchAssests
};

#import "AddAssestsViewController.h"
#import "AddAssestsHeaderView.h"
#import "AddAssestsService.h"
#import "CustomAssestsViewController.h"
#import "PYSearch.h"
#import "AddAssestsTableViewCell.h"
#import "RecommandToken.h"
#import "RecommandTokenResult.h"

@interface AddAssestsViewController ()<AddAssestsHeaderViewDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) AddAssestsHeaderView *headerView;
@property(nonatomic , strong) AddAssestsService *mainService;
@property(nonatomic, strong) UINavigationController *searchNavigationController;
@property(nonatomic , strong) UITableView *searchSuggestiontTabelView;
@property(nonatomic , assign) AddAssestsViewControllerCurrentAction addAssestsViewControllerCurrentAction;
@end

@implementation AddAssestsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"添加资产", nil)rightBtnImgName:@"search_icon" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (AddAssestsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddAssestsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 114);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (AddAssestsService *)mainService{
    if (!_mainService) {
        _mainService = [[AddAssestsService alloc] init];
    }
    return _mainService;
}

- (UITableView *)searchSuggestiontTabelView
{
    if (_searchSuggestiontTabelView == nil) {
        _searchSuggestiontTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        _searchSuggestiontTabelView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _searchSuggestiontTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchSuggestiontTabelView.estimatedRowHeight = 0;
        _searchSuggestiontTabelView.estimatedSectionHeaderHeight = 0;
        _searchSuggestiontTabelView.estimatedSectionFooterHeight = 0;
        _searchSuggestiontTabelView.delegate = self;
        _searchSuggestiontTabelView.dataSource = self;
        _searchSuggestiontTabelView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _searchSuggestiontTabelView.separatorColor = HEX_RGB(0xEEEEEE);
            
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _searchSuggestiontTabelView.separatorColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
        }
        
        if (@available(iOS 11.0, *)) {
            _searchSuggestiontTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _searchSuggestiontTabelView.scrollsToTop = YES;
        _searchSuggestiontTabelView.tableFooterView = [[UIView alloc] init];
    }
    return _searchSuggestiontTabelView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainService.get_recommand_token_request.accountName = self.accountName;
    [self loadNewData];
    [MobClick beginLogPageView:@"添加资产"]; //("Pagename"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"添加资产"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainService.get_recommand_token_request.accountName = self.accountName;
    [self.mainTableView.mj_header beginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddAssestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[AddAssestsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RecommandToken *model;
    if (self.addAssestsViewControllerCurrentAction == AddAssestsViewControllerActionSearchAssests) {
        model = self.mainService.searchTokenResultDataArray[indexPath.row];
    }else{
        model = self.mainService.dataSourceArray[indexPath.row];
    }
    WS(weakSelf);
    [cell setAssestsSwitchStatusDidChangeBlock:^(RecommandToken *token, UISwitch *assestsSwitch) {
        NSLog(@"%@, %d", token.assetName, assestsSwitch.isOn);
        NSLog(@"%@", weakSelf.mainService.followAssetIdsDataArray);
        if ([token.assetName isEqualToString:@"OCT"] || [token.assetName isEqualToString:@"EOS"]) {
            [TOASTVIEW showWithText: NSLocalizedString(@"该资产无法取消关注", nil)];
        }else{
            if (assestsSwitch.isOn) {
                if (![weakSelf.mainService.followAssetIdsDataArray containsObject: @(token.recommandToken_ID.integerValue)]) {
                    
                    [weakSelf.mainService.followAssetIdsDataArray addObject:@(token.recommandToken_ID.integerValue)];
                }
            }else{
                if ([weakSelf.mainService.followAssetIdsDataArray containsObject:@(token.recommandToken_ID.integerValue)]) {
                    [weakSelf.mainService.followAssetIdsDataArray removeObject:@(token.recommandToken_ID.integerValue)];
                }
            }
            
        }
        
    }];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.addAssestsViewControllerCurrentAction == AddAssestsViewControllerActionSearchAssests) {
        return self.mainService.searchTokenResultDataArray.count;
    }else{
        return self.mainService.dataSourceArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommandToken *model;
    if (self.addAssestsViewControllerCurrentAction == AddAssestsViewControllerActionSearchAssests) {
        model = self.mainService.searchTokenResultDataArray[indexPath.row];
    }else{
        model = self.mainService.dataSourceArray[indexPath.row];
    }
    if ([model.assetName isEqualToString:@"OCT"] || [model.assetName isEqualToString:@"EOS"]) {
        [TOASTVIEW showWithText: NSLocalizedString(@"该资产无法取消关注", nil)];
    }
}

//AddAssestsHeaderViewDelegate
- (void)customAssestsBtnDidClick{
    CustomAssestsViewController *vc = [[CustomAssestsViewController alloc] init];
    vc.accountName = self.accountName;
    [self.navigationController pushViewController:vc animated:YES];
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addAssestsViewControllerbackButtonDidClick:)]) {
        [self.delegate addAssestsViewControllerbackButtonDidClick:self.mainService.followAssetIdsDataArray];
    }
}

-(void)rightBtnDidClick{
    WS(weakSelf);
    self.addAssestsViewControllerCurrentAction = AddAssestsViewControllerActionSearchAssests;
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"请输入token名称或合约地址", nil)didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];
    
    searchViewController.showSearchHistory = NO;
    searchViewController.showHotSearch = NO;
    searchViewController.searchTextField.backgroundColor = HEXCOLOR(0xF5F5F5);
    searchViewController.searchSuggestionHidden = YES;
    // 4. Set delegate
    searchViewController.delegate = weakSelf;
    
    [self configSearchSuggestionTableViewWithSearchViewController:searchViewController];
    
    // 5. Present a navigation controller
    weakSelf.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [weakSelf presentViewController:weakSelf.searchNavigationController animated:YES completion:nil];
}

- (void)configSearchSuggestionTableViewWithSearchViewController:(PYSearchViewController *)searchViewController{
    [searchViewController.view addSubview: self.searchSuggestiontTabelView];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

- (void)searchViewController:(PYSearchViewController *)dsearchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText{
    WS(weakSelf);
    self.mainService.search_token_request.accountName = self.accountName;
    self.mainService.search_token_request.key = VALIDATE_STRING(searchText);
    [self.mainService search_token:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (self.mainService.searchTokenResultDataArray.count == 0) {
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.searchSuggestiontTabelView andViewController:weakSelf];
            }else{
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
            [weakSelf.searchSuggestiontTabelView reloadData];
        }
    }];
}

- (void)didClickCancel:(PYSearchViewController *)searchViewController{
    self.addAssestsViewControllerCurrentAction = AddAssestsViewControllerActionRecommandAssests;
    [self.mainService.searchTokenResultDataArray removeAllObjects];
    [self.searchSuggestiontTabelView removeFromSuperview];
    self.searchSuggestiontTabelView = nil;
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    [self.mainTableView.mj_footer resetNoMoreData];
    [self.mainService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshing];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
            }
            
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
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
