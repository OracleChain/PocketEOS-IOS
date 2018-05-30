//
//  MessageFeedbackViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "MessageFeedbackViewController.h"
#import "NavigationView.h"
#import "FeedbackHeaderView.h"
#import "MessageFeedbackService.h"
#import "MessageFeedbackResult.h"
#import "FeedbackTableViewCell.h"
#import "MessageFeedback.h"

@interface MessageFeedbackViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) FeedbackHeaderView *headerView;
@property(nonatomic, strong) MessageFeedbackService *mainService;
@end

@implementation MessageFeedbackViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"意见反馈" rightBtnTitleName:@"提交" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (FeedbackHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"FeedbackHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 260);
    }
    return _headerView;
}

- (MessageFeedbackService *)mainService{
    if (!_mainService) {
        _mainService = [[MessageFeedbackService alloc] init];
    }
    return _mainService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    [self.mainTableView.mj_header beginRefreshing];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[FeedbackTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    
    cell.backgroundColor = RandomColor;
    MessageFeedback *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFeedback *model = self.mainService.dataSourceArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[FeedbackTableViewCell class]  contentViewWidth:SCREEN_WIDTH];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnDidClick{
    self.mainService.postFeedbackRequest.uid = CURRENT_WALLET_UID;
    self.mainService.postFeedbackRequest.content = VALIDATE_STRING(self.headerView.feedbackTF.text);
    [self.mainService.postFeedbackRequest postDataSuccess:^(id DAO, id data) {
        NSString *str = VALIDATE_STRING(data[@"message"]);
        [TOASTVIEW showWithText:str];
    } failure:^(id DAO, NSError *error) {
        
    }];
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
