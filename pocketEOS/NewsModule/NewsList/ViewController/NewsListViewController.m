//
//  NewsListViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsService.h"
#import "News.h"
#import "NewsListCell.h"
#import "NewsDetailViewController.h"

@interface NewsListViewController ()
@property(nonatomic, strong) NewsService *mainService;
@end

@implementation NewsListViewController

- (NewsService *)mainService{
    if (!_mainService) {
        _mainService = [[NewsService alloc] init];
    }
    return _mainService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - CYCLESCROLLVIEW_HEIGHT - 40 - TABBAR_HEIGHT);
    [self.mainTableView.mj_header beginRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    News *news = (News *)self.mainService.dataSourceArray[indexPath.row];
    cell.model = news;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    News *news = (News *)self.mainService.dataSourceArray[indexPath.row];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
    if ([news.newsUrl hasPrefix: @"http"]) {
        vc.urlStr = news.newsUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"链接地址有误!", nil)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
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
