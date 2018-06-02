//
//  MessageCenterViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "NavigationView.h"
#import "MessageCenterTableViewCell.h"
#import "MessageCenterService.h"
#import "MessageCenterResult.h"


@interface MessageCenterViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) MessageCenterService *mainService;
@end

@implementation MessageCenterViewController
- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"消息中心" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (MessageCenterService *)mainService{
    if (!_mainService) {
        _mainService = [[MessageCenterService alloc] init];
    }
    return _mainService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =RGB(245, 245, 245);
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.mj_header beginRefreshing];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[MessageCenterTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    MessageCenter *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenter *model = self.mainService.dataSourceArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MessageCenterTableViewCell class]  contentViewWidth:SCREEN_WIDTH - (10 * 2)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
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
