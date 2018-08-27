//
//  TransactionRecordsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "TransactionRecordsViewController.h"
#import "TransactionRecordsHeaderView.h"
#import "NavigationView.h"
#import "PopUpWindow.h"
#import "ScanQRCodeViewController.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "AccountInfo.h"
#import "TransferRecordsTableViewCell.h"
#import "TransferDetailsViewController.h"

@interface TransactionRecordsViewController ()
<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, TransactionRecordsHeaderViewDelegate, PopUpWindowDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
@property(nonatomic, strong) TransactionRecordsHeaderView *headerView;
@property(nonatomic, strong) TransactionRecordsService *mainService;
@property(nonatomic, strong) NSString *currentAccountName;

@end

@implementation TransactionRecordsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"交易记录", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (PopUpWindow *)popUpWindow{
    if (!_popUpWindow) {
        _popUpWindow = [[PopUpWindow alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50 ))];
        _popUpWindow.delegate = self;
    }
    return _popUpWindow;
}

- (TransactionRecordsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TransactionRecordsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 52);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (TransactionRecordsService *)mainService{
    if (!_mainService) {
        _mainService = [[TransactionRecordsService alloc] init];
    }
    return _mainService;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"交易记录"]; //("Pagename"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"交易记录"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 52, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 52);
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.mj_header beginRefreshing];
    
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    for (AccountInfo *model in accountArray) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            AccountInfo *mainAccount = model;
            self.currentAccountName = mainAccount.account_name;
        }
    }
    
    self.headerView.accountLabel.text = self.currentAccountName;
    [self requestTransactionHistory];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransferRecordsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    TransactionRecord *model = self.mainService.dataSourceArray[indexPath.row];
    cell.currentAccountName = self.currentAccountName;
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecord *model = self.mainService.dataSourceArray[indexPath.row];
    TransferDetailsViewController *vc = [[TransferDetailsViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAccountBtnDidClick:(UIButton *)sender {
    
    NSArray *accountArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
    
//    for (AccountInfo *model in accountArr) {
//        if ([model.account_name isEqualToString:self.currentAccountName]) {
//            model.selected = YES;
//        }
//    }
    WS(weakSelf);
    [CDZPicker showSinglePickerInView:self.view withBuilder:[CDZPickerBuilder new] strings:accountArr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.currentAccountName = VALIDATE_STRING(strings[0]);
        weakSelf.headerView.accountLabel.text = weakSelf.currentAccountName;
        [weakSelf requestTransactionHistory];
    }cancel:^{
        NSLog(@"user cancled");
    }];
    
}


- (void)requestTransactionHistory{
    self.headerView.accountLabel.text = self.currentAccountName;
    self.mainService.getTransactionRecordsRequest.from = self.currentAccountName;
    self.mainService.getTransactionRecordsRequest.to = self.currentAccountName;
    self.mainService.getTransactionRecordsRequest.symbols = [NSMutableArray arrayWithObjects:@{@"symbolName":@"EOS"  , @"contractName": ContractName_EOSIOTOKEN }, @{@"symbolName":@"OCT"  , @"contractName": ContractName_OCTOTHEMOON },nil];
    [self loadNewData];
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
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshing];
                
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
                
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
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
