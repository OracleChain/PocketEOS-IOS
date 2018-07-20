//
//  CustomAssestsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CustomAssestsViewController.h"
#import "CustomAssestsHeaderView.h"
#import "CustomAssestsService.h"
#import "CustomAssestsTableViewCell.h"
#import "Add_user_token_request.h"
#import "CustomToken.h"
#import "Delete_user_custom_token_request.h"


@interface CustomAssestsViewController ()<CustomAssestsHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) CustomAssestsHeaderView *headerView;
@property(nonatomic , strong) CustomAssestsService *mainService;
@property(nonatomic , strong) Add_user_token_request *add_user_token_request;
@property(nonatomic , strong) Delete_user_custom_token_request *delete_user_custom_token_request;
@end

@implementation CustomAssestsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"自定义管理", nil)rightBtnImgName:nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (CustomAssestsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CustomAssestsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 195);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (CustomAssestsService *)mainService{
    if (!_mainService) {
        _mainService = [[CustomAssestsService alloc] init];
    }
    return _mainService;
}

- (Add_user_token_request *)add_user_token_request{
    if (!_add_user_token_request) {
        _add_user_token_request = [[Add_user_token_request alloc] init];
    }
    return _add_user_token_request;
}

- (Delete_user_custom_token_request *)delete_user_custom_token_request{
    if (!_delete_user_custom_token_request) {
        _delete_user_custom_token_request = [[Delete_user_custom_token_request alloc] init];
    }
    return _delete_user_custom_token_request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    [self buildDataSource];
    
}

- (void)buildDataSource{
    self.mainService.get_user_custom_token_request.accountName = self.accountName;
    [self loadNewData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomAssestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[CustomAssestsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    CustomToken *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    WS(weakSelf);
    [cell setOnTrashImageDidTapBlock:^(CustomToken *token) {
        weakSelf.delete_user_custom_token_request.accountName = weakSelf.accountName;
        weakSelf.delete_user_custom_token_request.recommandToken_ID = token.recommandToken_ID;
        [weakSelf.delete_user_custom_token_request postDataSuccess:^(id DAO, id data) {
            BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
            [TOASTVIEW showWithText:result.message];
            [weakSelf buildDataSource];
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


//CustomAssestsHeaderViewDelegate

- (void)confirmBtnDidClick{
    if (IsStrEmpty(self.headerView.tokenNameTF.text) || IsStrEmpty(self.headerView.contractAddressTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"输入不能为空!", nil)];
        return;
    }
    self.add_user_token_request.accountName = self.accountName;
    self.add_user_token_request.assetName = self.headerView.tokenNameTF.text;
    self.add_user_token_request.contractName = self.headerView.contractAddressTF.text;
    WS(weakSelf);
    [self.add_user_token_request postDataSuccess:^(id DAO, id data) {
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        [TOASTVIEW showWithText:result.message];
        [weakSelf buildDataSource];
    } failure:^(id DAO, NSError *error) {
        
    }];
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载a
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
@end
