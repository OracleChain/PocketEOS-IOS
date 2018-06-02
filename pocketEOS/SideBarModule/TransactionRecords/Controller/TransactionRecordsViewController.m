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
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"交易记录" rightBtnImgName:@"" delegate:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 52, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 52);
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.mj_header beginRefreshing];
    
    [self loadAllBlocks];
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    for (AccountInfo *model in accountArray) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            AccountInfo *mainAccount = model;
            self.currentAccountName = mainAccount.account_name;
        }
    }
    self.headerView.accountLabel.text = self.currentAccountName;
    self.mainService.getTransactionRecordsRequest.account_name = self.currentAccountName;
}

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.popUpWindow setOnBottomViewDidClick:^{
        
        [weakSelf removePopUpWindow];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransactionRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
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
    NSLog(@"%@", indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAccountBtnDidClick:(UIButton *)sender {
    
    if (sender.selected) {
        [self.view addSubview:self.popUpWindow];
        NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
        self.popUpWindow.type = PopUpWindowTypeAccount;
        for (AccountInfo *model in accountArr) {
            if ([model.account_name isEqualToString:self.currentAccountName]) {
                model.selected = YES;
            }
        }
        [_popUpWindow updateViewWithArray:accountArr title:@""];
    }else{
        [self removePopUpWindow];
    }
}

//PopUpWindowDelegate
-(void)popUpWindowdidSelectItem:(id)sender{
    AccountInfo *accountInfo = sender;
    self.mainService.getTransactionRecordsRequest.account_name = accountInfo.account_name;
    self.headerView.accountLabel.text = accountInfo.account_name;
    self.currentAccountName = accountInfo.account_name;
    [self removePopUpWindow];
    [self loadNewData];
}


- (void)removePopUpWindow{
    [self.popUpWindow removeFromSuperview];
    self.popUpWindow = nil;
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
                
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:@"暂无数据" toView:weakSelf.mainTableView andViewController:weakSelf];
                
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
           [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:@"暂无数据" toView:weakSelf.mainTableView andViewController:weakSelf];
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
