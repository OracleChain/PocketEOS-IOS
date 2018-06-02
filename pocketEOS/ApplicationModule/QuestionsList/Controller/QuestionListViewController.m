//
//  QuestionListViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "QuestionListViewController.h"
#import "QuestionListHeaderView.h"
#import "SegmentControlView.h"
#import "AskQuestionViewController.h"
#import "QuestionListService.h"
#import "QuestionListTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "CDZPicker.h"
#import "SelectAccountView.h"

NSString * const AskQuestionDidSuccessNotification = @"AskQuestionDidSuccessNotification";

@interface QuestionListViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, QuestionListHeaderViewDelegate, SegmentControlViewDelegate, SelectAccountViewDelegate>
@property(nonatomic, strong) QuestionListHeaderView *headerView;
@property(nonatomic, strong) UIView *segmentControlViewBackgroundView;
@property(nonatomic, strong) SegmentControlView *segmentControlView;
@property(nonatomic, strong) UIButton *askQuestionBtn;
@property(nonatomic, strong) QuestionListService *mainService;
@property(nonatomic, strong) SelectAccountView *selectAccountView;
@property(nonatomic, strong) NSString *choosedAccountName;
@end

@implementation QuestionListViewController

- (QuestionListHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[QuestionListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 200 / 375  + 54)];
        _headerView.delegate = self;
        _headerView.segmentControlView.delegate = self;
    }
    return _headerView;
}

- (UIView *)segmentControlViewBackgroundView{
    if (!_segmentControlViewBackgroundView) {
        _segmentControlViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _segmentControlViewBackgroundView.backgroundColor = [UIColor whiteColor];
        _segmentControlView = [[SegmentControlView alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT-54, SCREEN_WIDTH, 54))];
        [_segmentControlViewBackgroundView addSubview:self.segmentControlView];
        _segmentControlView.delegate = self;
        [_segmentControlView updateViewWithArray:[NSMutableArray arrayWithObjects:@"现有问题", @"过往问题",  nil]];
    }
    return _segmentControlViewBackgroundView;
}

- (UIButton *)askQuestionBtn{
    if(!_askQuestionBtn){
        _askQuestionBtn = [[UIButton alloc] init];
        [_askQuestionBtn setTitle:@"提问" forState:(UIControlStateNormal)];
        _askQuestionBtn.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0x4D7BFE)).LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
        _askQuestionBtn.layer.masksToBounds = YES;
        _askQuestionBtn.layer.cornerRadius = 28;
        [_askQuestionBtn addTarget: self action: @selector(askQuestionBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    return _askQuestionBtn;
}

- (QuestionListService *)mainService{
    if (!_mainService) {
        _mainService = [[QuestionListService alloc] init];
    }
    return _mainService;
}

- (SelectAccountView *)selectAccountView{
    if (!_selectAccountView) {
        _selectAccountView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAccountView" owner:nil options:nil] firstObject];
        _selectAccountView.frame = self.view.bounds;
        _selectAccountView.delegate = self;
    }
    return _selectAccountView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainService.getQuestionListRequest.releasedLable = @0;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    
    [self.headerView updateViewWithArray:[NSMutableArray arrayWithObjects:@"现有问题", @"过往问题",  nil]];
    [self.view addSubview:self.selectAccountView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(askQuestionDidFinish) name:AskQuestionDidSuccessNotification object:nil];
}

- (void)askQuestionDidFinish{
    [self loadNewData];
}

- (void)addAskQuestionBtn{
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = HEXCOLOR(0x4D7BFE);
    shadowView.layer.shadowOffset = CGSizeMake(0, 5);
    shadowView.layer.shadowColor = HEXCOLOR(0x4D7BFE).CGColor;
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.cornerRadius = 28;
    shadowView.frame = CGRectMake(SCREEN_WIDTH - MARGIN_20 - 56, SCREEN_HEIGHT - MARGIN_20 - 56, 56, 56);
    [self.view addSubview: shadowView];
    
    [self.view addSubview:self.askQuestionBtn];
    self.askQuestionBtn.sd_layout.rightSpaceToView(self.view, MARGIN_20).bottomSpaceToView(self.view, MARGIN_20).widthIs(56).heightEqualToWidth();
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[QuestionListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    Question *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *model = self.mainService.dataSourceArray[indexPath.row];
    NSLog(@"%@", model.asktitle);
    QuestionDetailViewController *vc = [[QuestionDetailViewController alloc] init];
    vc.question = model;
    vc.choosedAccountName = self.choosedAccountName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *model = self.mainService.dataSourceArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QuestionListTableViewCell class]  contentViewWidth:SCREEN_WIDTH];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

- (void)backBtnDidClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    WS(weakSelf);
    if (scrollView.contentOffset.y >= SCREEN_WIDTH * 200 / 375) {
        // 显示
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view addSubview:weakSelf.segmentControlViewBackgroundView];
        }];
    }else{
        // 隐藏
        if (weakSelf.segmentControlViewBackgroundView) {
            [weakSelf.segmentControlViewBackgroundView removeFromSuperview];
        }
    }
}
- (void)askQuestionBtnClick:(UIButton *)sender{
    AskQuestionViewController *vc = [[AskQuestionViewController alloc] init];
    vc.choosedAccountName = self.choosedAccountName;
    [self.navigationController pushViewController:vc animated:YES];
}


//SegmentControlViewDelegate
- (void)segmentControlBtnDidClick:(UIButton *)sender{
    /**
     releasedLable=0表示问题还可以回答releasedLable=1表示以往问题
     */
    if (sender.tag == 1000) {
        self.mainService.getQuestionListRequest.releasedLable = @0;
    }else if (sender.tag == 1001){
        self.mainService.getQuestionListRequest.releasedLable = @1;
    }
    [self loadNewData];
}

//SelectAccountViewDelegate
- (void)selectAccountBtnDidClick:(UIButton *)sender{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = UIColor.redColor;
    WS(weakSelf);
    
    NSArray *accountNameArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
    if (accountNameArr.count == 0) {
        [TOASTVIEW showWithText:@"暂无账号!"];
        return;
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:[[AccountsTableManager accountTable] selectAllNativeAccountName] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.selectAccountView.accountChooseLabel.text = [NSString stringWithFormat:@"%@" , strings[0]];
        weakSelf.choosedAccountName = VALIDATE_STRING(strings[0]);
    }cancel:^{
        [weakSelf.selectAccountView removeFromSuperview];
    }];
    
}

- (void)understandBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.choosedAccountName)) {
        [TOASTVIEW showWithText:@"请选择您将选择的账号!"];
        return;
    } else{
        [self.selectAccountView removeFromSuperview];
        [self addAskQuestionBtn];
        self.mainService.getQuestionListRequest.releasedLable = @0;
        [self configRefreshComponent];
    }
}

-(void)backgroundViewDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载
- (void)configRefreshComponent
{
    WS(weakSelf);
    [self loadNewData];
    // 下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.mainTableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
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
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else if(dataCount.integerValue < PER_PAGE_SIZE_15){
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AskQuestionDidSuccessNotification object:nil];
}

@end
