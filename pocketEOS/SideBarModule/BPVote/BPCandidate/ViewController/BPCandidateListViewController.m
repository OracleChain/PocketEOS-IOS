//
//  BPCandidateListViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateListViewController.h"
#import "BPCandidateFooterView.h"
#import "BPCandidateTableViewCell.h"
#import "BPCandidateService.h"
#import "BPVoteAmountViewController.h"
#import "BPCandidateModel.h"
#import "BPCandidateDetailViewController.h"
#import "RtfBrowserWithoutThemeViewController.h"

@interface BPCandidateListViewController ()<NavigationViewDelegate, BPCandidateFooterViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) BPCandidateFooterView *footerView;
@property(nonatomic , strong) BPCandidateService *mainService;
@property(nonatomic , strong) NSMutableArray *choosedBPDataArray;
@end

@implementation BPCandidateListViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"节点投票", nil)rightBtnTitleName:NSLocalizedString(@"投票规则", nil)delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
        [_navView.rightBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
    }
    return _navView;
}

- (BPCandidateFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"BPCandidateFooterView" owner:nil options:nil] firstObject];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        _footerView.delegate = self;
    }
    return _footerView;
}

- (NSMutableArray *)choosedBPDataArray{
    if (!_choosedBPDataArray) {
        _choosedBPDataArray = [[NSMutableArray alloc] init];
    }
    return _choosedBPDataArray;
}

- (BPCandidateService *)mainService{
    if (!_mainService) {
        _mainService = [[BPCandidateService alloc] init];
    }
    return _mainService;
}
- (Account *)model{
    if (!_model) {
        _model = [[Account alloc] init];
    }
    return _model;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0x000000);
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = HEXCOLOR(0x000000);
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT);
    [self.view addSubview:self.footerView];
    [self.mainTableView.mj_header beginRefreshing];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BPCandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BPCandidateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    BPCandidateModel *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    [cell setOnAvatarViewClick:^{
        BPCandidateDetailViewController *vc = [[BPCandidateDetailViewController alloc] init];
        if ([model.url hasPrefix: @"http"]) {
            vc.urlStr = model.url;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [TOASTVIEW showWithText:NSLocalizedString(@"链接地址有误!", nil)];
        }
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BPCandidateModel *model = self.mainService.dataSourceArray[indexPath.row];
    if ([self.choosedBPDataArray containsObject:model] ) {
        [self.choosedBPDataArray removeObject:model];
        model.isSelected = NO;
    }else{
        [self.choosedBPDataArray addObject:model];
        model.isSelected = YES;
    }
    [self.mainTableView reloadData];
    NSInteger remainCount = 30-self.choosedBPDataArray.count;
    self.footerView.tipLabel.text = [NSString stringWithFormat:@"已选择%ld个，还可以选择%ld个", self.choosedBPDataArray.count, remainCount ];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    BPCandidateModel *model = self.mainService.dataSourceArray[indexPath.row];
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BPCandidateTableViewCell class]  contentViewWidth:SCREEN_WIDTH];
    return 80;
}

//BPCandidateFooterViewDelegate
- (void)confirmBtnDidClick{
    if (self.choosedBPDataArray.count == 0) {
        [TOASTVIEW showWithText:@"至少选择一个投票节点!"];
        return ;
    }
    BPVoteAmountViewController *vc = [[BPVoteAmountViewController alloc] init];
    vc.model = self.model;
    vc.choosedBPDataArray = self.choosedBPDataArray;
    vc.myVoteInfoResult = self.myVoteInfoResult;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    RtfBrowserWithoutThemeViewController *vc = [[RtfBrowserWithoutThemeViewController alloc] init];
    vc.rtfFileName = @"BPVoteRules";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    [self.mainTableView.mj_footer resetNoMoreData];
    [self.mainService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
            }else if(dataCount.integerValue < PER_PAGE_SIZE_15){
                // 拿到当前的下拉刷新控件，结束刷新状态
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
            [weakSelf.mainTableView.mj_header setHidden:YES];
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
