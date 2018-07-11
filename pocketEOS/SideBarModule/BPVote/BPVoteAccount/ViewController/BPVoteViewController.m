//
//  BPVoteViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteViewController.h"
#import "NavigationView.h"
#import "BPVoteHeaderView.h"
#import "CDZPicker.h"
#import "BPVoteFooterView.h"
#import "BPAgentVoteViewController.h"
#import "BPCandidateListViewController.h"
#import "GetAccountAssetRequest.h"
#import "Account.h"
#import "BPVoteService.h"
#import "MyVoteInfo.h"
#import "MyVoteProduce.h"
#import "MyVoteInfoResult.h"

@interface BPVoteViewController ()<NavigationViewDelegate, BPVoteHeaderViewDelegate, BPVoteFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) UIImageView *img;
@property(nonatomic , strong) BaseLabel1 *tipLabel;
@property(nonatomic , strong) BPVoteHeaderView *headerView;
@property(nonatomic , strong) BPVoteFooterView *footerView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) GetAccountAssetRequest *getAccountAssetRequest;
@property(nonatomic , strong) Account *accountModel;
@property(nonatomic , strong) BPVoteService *mainService;
@property(nonatomic , strong) MyVoteInfoResult *myVoteInfoResult;
@end

@implementation BPVoteViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"节点投票", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    }
    return _navView;
    
}

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _img;
}

- (BaseLabel1 *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[BaseLabel1 alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (BPVoteHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BPVoteHeaderView" owner:nil options:nil] firstObject];
//        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 243);
        _headerView.delegate = self;
        
    }
    return _headerView;
}

- (BPVoteFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BPVoteFooterView alloc] init];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT- TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        _footerView.delegate = self;
    }
    return _footerView;
}

- (GetAccountAssetRequest *)getAccountAssetRequest{
    if (!_getAccountAssetRequest) {
        _getAccountAssetRequest = [[GetAccountAssetRequest alloc] init];
    }
    return _getAccountAssetRequest;
}

- (BPVoteService *)mainService{
    if (!_mainService) {
        _mainService = [[BPVoteService alloc] init];
    }
    return _mainService;
}

- (Account *)accountModel{
    if (!_accountModel) {
        _accountModel = [[Account alloc] init];
    }
    return _accountModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMyVoteInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    [self.view addSubview:self.footerView];
   
    NSArray *arr = @[NSLocalizedString(@"去投票", nil), NSLocalizedString(@"委托投票", nil)];
    [self.footerView updateViewWithArray:arr];
    self.view.backgroundColor = HEXCOLOR(0x000000);
    self.mainTableView.backgroundColor = HEXCOLOR(0x000000);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    for (AccountInfo *model in accountArray) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            AccountInfo *mainAccount = model;
            self.currentAccountName = mainAccount.account_name;
            self.headerView.accountNameLabel.text = self.currentAccountName;
        }
    }
    // 请求账号余额
    [self buildDataSource];
    
    // 请求账号投票信息
    [self requestMyVoteInfo];
}

- (void)requestMyVoteInfo{
    WS(weakSelf);
    self.mainService.getMyVoteInfoRequest.accountNameStr = self.currentAccountName;
    [self.mainService buildDataSource:^(MyVoteInfoResult *result, BOOL isSuccess) {
        [weakSelf.mainTableView.mj_header endRefreshing];
        [weakSelf.mainTableView.mj_footer resetNoMoreData];
        if (isSuccess) {
            weakSelf.myVoteInfoResult = result;
            [weakSelf.mainTableView reloadData];
        }else{
        }
    }];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.getAccountAssetRequest.name = self.currentAccountName;
    [self.getAccountAssetRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.mainTableView.mj_header endRefreshing];
        [weakSelf.mainTableView.mj_footer resetNoMoreData];
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            AccountResult *result = [AccountResult mj_objectWithKeyValues:data];
            weakSelf.headerView.model = result;
            weakSelf.accountModel = result.data;
            weakSelf.headerView.accountNameLabel.text = weakSelf.currentAccountName;
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
         [weakSelf.mainTableView.mj_footer resetNoMoreData ];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    cell.contentView.backgroundColor = HEXCOLOR(0x000000);
    cell.textLabel.textColor = HEXCOLOR(0xFFFFFF);
    cell.detailTextLabel.textColor = HEXCOLOR(0xFFFFFF);
    cell.bottomLineView.backgroundColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
    MyVoteProduce *model = self.mainService.dataSourceArray[indexPath.row];
    cell.textLabel.text = model.owner;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.4f亿票", self.myVoteInfoResult.info.last_vote_weight.doubleValue/ 1000000000000];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43.5;
}

- (void)changeAccountBtnDidClick:(UIButton *)sender{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    WS(weakSelf);
    
    NSArray *accountNameArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
    if (accountNameArr.count == 0) {
        [TOASTVIEW showWithText:NSLocalizedString(@"暂无账号!", nil)];
        return;
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:[[AccountsTableManager accountTable] selectAllNativeAccountName] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.headerView.accountNameLabel.text = [NSString stringWithFormat:@"%@" , strings[0]];
        weakSelf.currentAccountName = VALIDATE_STRING(strings[0]);
        [weakSelf buildDataSource];
        [weakSelf requestMyVoteInfo];
        
    }cancel:^{
        
    }];
    
}



//BPVoteFooterViewDelegate
-(void)bpFooterViewBottomBtnDidClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        BPCandidateListViewController *vc = [[BPCandidateListViewController alloc] init];
        vc.model = self.accountModel;
        vc.model.account_name = self.currentAccountName;
        vc.myVoteInfoResult = self.myVoteInfoResult;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){
        BPAgentVoteViewController *vc = [[BPAgentVoteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)loadNewData{
    [self buildDataSource];
    [self requestMyVoteInfo];
}

- (void)loadMoreData{
    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
