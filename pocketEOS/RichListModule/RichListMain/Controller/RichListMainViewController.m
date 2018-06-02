//
//  RichListMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RichListMainViewController.h"
#import "SideBarViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "RichlistHeaderView.h"
#import "RichListService.h"
#import "NavigationView.h"
#import "RichListCell.h"
#import "IndexTipView.h"
#import "Follow.h"
#import "RichlistDetailViewController.h"
#import "PYSearch.h"
#import "EnterpriseListViewController.h"
#import "PeRichListViewController.h"
#import "GetAccountResult.h"
#import "GetAccount.h"


@interface RichListMainViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,NavigationViewDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property(nonatomic, strong) RichlistHeaderView *headerView;
@property(nonatomic, strong) RichListService *mainService;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) IndexTipView *indexTipView;
@property(nonatomic, strong) UINavigationController *searchNavigationController;
@end

@implementation RichListMainViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:@"富豪榜" rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}
- (RichlistHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RichlistHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
        
    }
    return _headerView;
}

- (RichListService *)mainService{
    if (!_mainService) {
        _mainService = [[RichListService alloc] init];
    }
    return _mainService;
}

- (IndexTipView *)indexTipView{
    if (!_indexTipView) {
        _indexTipView = [[IndexTipView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT / 2, 40, 33)];
    }
    return _indexTipView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    [self buildDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView: self.headerView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self loadAllBlocks];
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    
}
- (void)buildDataSource{
    WS(weakSelf);
    self.mainService.richListRequest.uid = CURRENT_WALLET_UID;
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        if (weakSelf.mainService.keysArray.count > 0) {
            [weakSelf.mainTableView reloadData];
            
        }
        
    }];
}

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.headerView setOnSearchFriendsBlock:^{
        // Create a search view controller
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索好友" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
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
        // 5. Present a navigation controller
        weakSelf.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [weakSelf presentViewController:weakSelf.searchNavigationController animated:YES completion:nil];
    }];
    
    [self.headerView setOnEnterPriseBlock:^{
        EnterpriseListViewController *vc = [[EnterpriseListViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setOnPeListBlock:^{
        PeRichListViewController *vc = [[PeRichListViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}


#pragma mark - tableviewDataSource & delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainService.keysArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\
    
    RichListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[RichListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    NSString *key = self.mainService.keysArray[indexPath.section];
    NSArray *FollowsArr = [self.mainService.dataDictionary objectForKey: key];
    Follow *model = FollowsArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.mainService.keysArray[indexPath.section];
    NSArray *followsArr = [self.mainService.dataDictionary objectForKey: key];
    Follow *model = followsArr[indexPath.row];
    NSLog(@"%@", model.displayName);
    RichlistDetailViewController *vc = [[RichlistDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.mainService.keysArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    self.indexTipView.hidden = NO;
    self.indexTipView.text = title;
    [self.navigationController.view addSubview:self.indexTipView];
    [self performSelector:@selector(hideIndexTipView) withObject:nil afterDelay:0.5];
    return index;
}

- (void)hideIndexTipView{
    self.indexTipView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.mainService.dataDictionary objectForKey: self.mainService.keysArray[section]];
    return arr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = HEXCOLOR(0xF5F5F5);
    headerLabel.text = [NSString stringWithFormat:@"    %@", self.mainService.keysArray[section]];
    headerLabel.font = [UIFont systemFontOfSize:11];
    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.5;
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

- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText{
    self.mainService.getAccountRequest.name = VALIDATE_STRING(searchText);
    [self.mainService.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            RichlistDetailViewController *vc = [[RichlistDetailViewController alloc] init];
            Follow *follow = [[Follow alloc] init];
            follow.displayName = model.account_name;
            follow.followType = @2;
            [self.searchNavigationController dismissViewControllerAnimated:NO completion:nil];
            vc.model = follow;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
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
@end
