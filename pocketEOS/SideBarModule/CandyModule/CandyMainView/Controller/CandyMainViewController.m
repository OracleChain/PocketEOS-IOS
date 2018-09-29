//
//  CandyMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CandyMainViewController.h"
#import "NavigationView.h"
#import "CandyMainHeaderView.h"
#import "CandyTopView.h"
#import "CandyMainTableViewCell.h"
#import "FeedbackTableViewCell.h"
#import "CandyTaskModel.h"
#import "CandyMainService.h"
#import "CandyScoreRequest.h"
#import "CommonWKWebViewController.h"

@interface CandyMainViewController ()<NavigationViewDelegate>
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) CandyMainHeaderView *headerView;
@property(nonatomic , strong) CandyTopView *topView;
@property(nonatomic , strong) CandyMainService *mainService;
@property(nonatomic , strong) CandyScoreRequest *candyScoreRequest;
@end

@implementation CandyMainViewController

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 128))];
        _backgroundView.image = [UIImage imageNamed:@"candyBackground_blue"];
    }
    return _backgroundView;
}


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"糖果积分", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = [UIColor clearColor];
        _navView.titleLabel.textColor = [UIColor whiteColor];
    }
    return _navView;
}

- (CandyMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CandyMainHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255);
    }
    return _headerView;
}

- (CandyTopView *)topView{
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"CandyTopView" owner:nil options:nil] firstObject];
        _topView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 128);
    }
    return _topView;
}

- (CandyMainService *)mainService{
    if (!_mainService) {
        _mainService = [[CandyMainService alloc] init];
    }
    return _mainService;
}
- (CandyScoreRequest *)candyScoreRequest{
    if (!_candyScoreRequest) {
        _candyScoreRequest = [[CandyScoreRequest alloc] init];
    }
    return _candyScoreRequest;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestCandyScoreRequest];
    [MobClick beginLogPageView:@"糖果积分"]; //("Pagename"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"糖果积分"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 128, SCREEN_WIDTH, SCREEN_HEIGHT-128-NAVIGATIONBAR_HEIGHT);
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildDataSource];
    [self loadAllBlocks];
}

- (void)buildDataSource{
    WS(weakSelf);
    Wallet *wallet = CURRENT_WALLET;
    [self.topView.avatarImgView sd_setImageWithURL:String_To_URL(wallet.wallet_img) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer resetNoMoreData];
    
    [self.mainService getCandyTasks:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
    
    [self.mainService getCandyEquities:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.headerView.dataArray = weakSelf.mainService.candEquityDatasourceArray;
            [weakSelf.headerView.mainCollectionView reloadData ];
        }
    }];
    
}

- (void)requestCandyScoreRequest{
    WS(weakSelf);
    self.candyScoreRequest.uid = CURRENT_WALLET_UID;
    [self.candyScoreRequest getDataSusscess:^(id DAO, id data) {
        weakSelf.topView.myPointsLabel.text = [NSString stringWithFormat:@"+%@", VALIDATE_NUMBER(data[@"data"][@"scoreNum"])];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.headerView setOnCandyMainCollectionCellDidSelectItemBlock:^(CandyEquityModel *model) {
        if ([model.equity_id isEqualToString:@"86347ee1d8cb412a8e793f48cb483a41"]) {
            CommonWKWebViewController *vc = [[CommonWKWebViewController alloc] init];
            vc.urlStr = model.exchangeUrl;
            vc.parameterStr =[NSString stringWithFormat:@"?uid=%@&id=%@", CURRENT_WALLET_UID, model.equity_id];
            vc.title = model.title;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [TOASTVIEW showWithText:model.equity_description];
        }
    }];
}

// UITableViewDelegate && DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CandyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEUDENTIFIER1];
    if (!cell) {
        cell = [[CandyMainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEUDENTIFIER1];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    CandyTaskModel *model = self.mainService.candyTaskDatasourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.candyTaskDatasourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
