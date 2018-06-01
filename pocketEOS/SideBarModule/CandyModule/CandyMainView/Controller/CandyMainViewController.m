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
#import "CandyMainTableViewCell.h"
#import "FeedbackTableViewCell.h"
#import "CandyTaskModel.h"
#import "CandyMainService.h"
#import "CandyScoreRequest.h"

@interface CandyMainViewController ()<NavigationViewDelegate>
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) CandyMainHeaderView *headerView;
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
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:@"糖果积分" rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = [UIColor clearColor];
        _navView.titleLabel.textColor = [UIColor whiteColor];
    }
    return _navView;
}

- (CandyMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CandyMainHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 383);
    }
    return _headerView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.scrollEnabled = NO;
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    Wallet *wallet = CURRENT_WALLET;
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer resetNoMoreData];
    self.candyScoreRequest.uid = CURRENT_WALLET_UID;
    [self.candyScoreRequest getDataSusscess:^(id DAO, id data) {
        [weakSelf.headerView.avatarImgView sd_setImageWithURL:String_To_URL(wallet.wallet_avatar) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
        weakSelf.headerView.myPointsLabel.text = [NSString stringWithFormat:@"+%@", VALIDATE_NUMBER(data[@"data"][@"scoreNum"])];
    } failure:^(id DAO, NSError *error) {
        
    }];
    
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
