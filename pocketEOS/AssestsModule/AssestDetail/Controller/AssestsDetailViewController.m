//
//  AssestsDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AssestsDetailViewController.h"
#import "AssestsDetailHeaderView.h"
#import "NavigationView.h"
#import "TransferViewController.h"
#import "RecieveViewController.h"
#import "RedPacketViewController.h"
#import "TendencyChartView.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "TransactionRecord.h"
#import "GetSparklinesRequest.h"
#import "AssestsShareDetailView.h"
#import "SocialSharePanelView.h"
#import "SocialShareModel.h"
#import "SocialManager.h"
#import "AssestDetailFooterView.h"

@interface AssestsDetailViewController ()< UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, AssestsDetailHeaderViewDelegate, SocialSharePanelViewDelegate, AssestDetailFooterViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) AssestsDetailHeaderView *headerView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) NSString *currentAssestsType;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@property(nonatomic , strong) GetSparklinesRequest *getSparklinesRequest;
@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) AssestsShareDetailView *assestsShareDetailView;
@property(nonatomic , strong) NSArray *platformNameArr;
@property(nonatomic , strong) AssestDetailFooterView *footerView;
@end

@implementation AssestsDetailViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资产", nil)rightBtnImgName:@"share" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _navView.rightBtn.hidden = NO;
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _navView.rightBtn.hidden = YES;
        }
    }
    return _navView;
}

- (AssestsDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 233);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (AssestDetailFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[AssestDetailFooterView alloc] init];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        _footerView.delegate = self;
    }
    return _footerView;
}

- (AssestsShareDetailView *)assestsShareDetailView{
    if (!_assestsShareDetailView) {
        _assestsShareDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsShareDetailView" owner:nil options:nil] firstObject];
        _assestsShareDetailView.backgroundColor = HEXCOLOR(0xF7F7F7);
    }
    return _assestsShareDetailView;
}

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.backgroundColor = HEXCOLOR(0xF7F7F7);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"朋友圈", nil), NSLocalizedString(@"QQ好友", nil), NSLocalizedString(@"QQ空间", nil)];
        for (int i = 0; i < 4; i++) {
            SocialShareModel *model = [[SocialShareModel alloc] init];
            model.platformName = titleArr[i];
            model.platformImage = self.platformNameArr[i];
            [modelArr addObject:model];
        }
        self.socialSharePanelView.labelTopSpace = 33;
        [_socialSharePanelView updateViewWithArray:modelArr];
    }
    return _socialSharePanelView;
}

- (NSArray *)platformNameArr{
    if (!_platformNameArr) {
        _platformNameArr = @[@"wechat_friends",@"wechat_moments", @"qq_friends", @"qq_Zone"];
    }
    return _platformNameArr;
}

- (UIView *)shareBaseView{
    if (!_shareBaseView) {
        _shareBaseView = [[UIView alloc] init];
        _shareBaseView.userInteractionEnabled = YES;
        _shareBaseView.backgroundColor = [UIColor clearColor];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor blackColor];
        topView.alpha = 0.5;
        topView.userInteractionEnabled = YES;
        [_shareBaseView addSubview:topView];
        topView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).topSpaceToView(_shareBaseView, 0).heightIs(SCREEN_HEIGHT - 47 - 116 - 153);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [topView addGestureRecognizer:tap];
        
        UIButton *cancleBtn = [[UIButton alloc] init];
        [cancleBtn setTitle:NSLocalizedString(@"取消", nil)forState:(UIControlStateNormal)];
        [cancleBtn setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [cancleBtn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
        [cancleBtn addTarget:self action:@selector(cancleShareAssestsDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareBaseView addSubview:cancleBtn];
        cancleBtn.sd_layout.leftSpaceToView(_shareBaseView ,0 ).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_shareBaseView, 0).heightIs(47);
        
        [_shareBaseView addSubview:self.socialSharePanelView];
        _socialSharePanelView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(cancleBtn, 0).heightIs(116);
        
        [_shareBaseView addSubview: self.assestsShareDetailView];
        _assestsShareDetailView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_socialSharePanelView, 0).heightIs(153);
       
    }
    return _shareBaseView;
}

- (TransactionRecordsService *)transactionRecordsService{
    if (!_transactionRecordsService) {
        _transactionRecordsService = [[TransactionRecordsService alloc] init];
    }
    return _transactionRecordsService;
}
- (GetSparklinesRequest *)getSparklinesRequest{
    if (!_getSparklinesRequest) {
        _getSparklinesRequest = [[GetSparklinesRequest alloc] init];
    }
    return _getSparklinesRequest;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.currentAccountName = self.accountName;
    self.currentAssestsType = self.model.assestsName;
    self.transactionRecordsService.getTransactionRecordsRequest.account_name = self.accountName;
    [self loadNewData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    [self.view addSubview:self.footerView];
    [self configHeaderView];
   
//     [self.mainTableView.mj_header beginRefreshing];
//    NSValue *value0 = [NSValue valueWithCGPoint:(CGPointMake(0, 40))];
//    NSValue *value1 = [NSValue valueWithCGPoint:(CGPointMake(10, 20))];
//    NSValue *value2 = [NSValue valueWithCGPoint:(CGPointMake(15, 70))];
//    NSValue *value3 = [NSValue valueWithCGPoint:(CGPointMake(20, 20))];
//    NSValue *value4 = [NSValue valueWithCGPoint:(CGPointMake(25, 60))];
//    NSValue *value5 = [NSValue valueWithCGPoint:(CGPointMake(30, 66))];
//    NSValue *value6 = [NSValue valueWithCGPoint:(CGPointMake(35, 70))];
//    NSValue *value7 = [NSValue valueWithCGPoint:(CGPointMake(40, 7))];
//    NSValue *value8 = [NSValue valueWithCGPoint:(CGPointMake(45, 88))];
//    NSValue *value9 = [NSValue valueWithCGPoint:(CGPointMake(50, 30))];
//    NSValue *value10 = [NSValue valueWithCGPoint:(CGPointMake(100, 40))];
//    NSValue *value11 = [NSValue valueWithCGPoint:(CGPointMake(120, 20))];
//    NSValue *value12 = [NSValue valueWithCGPoint:(CGPointMake(160, 70))];
//    NSValue *value13 = [NSValue valueWithCGPoint:(CGPointMake(200, 20))];
//    NSValue *value14 = [NSValue valueWithCGPoint:(CGPointMake(220, 60))];
//    NSValue *value15 = [NSValue valueWithCGPoint:(CGPointMake(230, 66))];
//    NSValue *value16 = [NSValue valueWithCGPoint:(CGPointMake(240, 70))];
//    NSValue *value17 = [NSValue valueWithCGPoint:(CGPointMake(260, 7))];
//    NSValue *value18 = [NSValue valueWithCGPoint:(CGPointMake(280, 88))];
//    NSValue *value19 = [NSValue valueWithCGPoint:(CGPointMake(300, 30))];
//    NSMutableArray *arr = [NSMutableArray arrayWithObjects:value0, value1 , value2 , value3 , value4 , value5 , value6 , value7 , value8 , value9   ,value10, value11 , value12 , value13 , value14 , value15 , value16 , value17 , value18 , value19  ,nil];
//
//    self.headerView.tendencyChartView.pointArray = arr;
//    [self.headerView.tendencyChartView drawBulletLayer];
//    [self.headerView.tendencyChartView animation];
    
    
}

- (void)configHeaderView{
    self.headerView.amountLabel.text = [NSString stringWithFormat:@"%@ CNY", [NumberFormatter displayStringFromNumber:@(self.model.assests_balance.doubleValue * self.model.assests_price_cny.doubleValue)]];
    if ([self.model.assests_price_change_in_24 hasPrefix:@"-"]) {
        //        HEXCOLOR(0x1E903C) HEXCOLOR(0xB0B0B0)
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%%   24h", self.model.assests_price_change_in_24]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0xB51515)
                           range:NSMakeRange(0, self.model.assests_price_change_in_24.length + 1)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0xB51515)
                           range:NSMakeRange(self.model.assests_price_change_in_24.length+1, 6)];
        self.headerView.fluctuateLabel.attributedText = attrString;
    }else{
        //B51515
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"+%@%%   24h", self.model.assests_price_change_in_24]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x1E903C)
                           range:NSMakeRange(0, self.model.assests_price_change_in_24.length + 2)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x1E903C)
                           range:NSMakeRange(self.model.assests_price_change_in_24.length + 2, 6)];
        
        self.headerView.fluctuateLabel.attributedText = attrString;
    }

    self.headerView.totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"额(24h)%@CNY", nil), self.model.assests_market_cap_cny];
    self.headerView.accountLabel.text = self.accountName;
    if ([self.model.assestsName isEqualToString:@"eos"]) {
        self.headerView.Assest_balance_Label.text = [NSString stringWithFormat:@"%@ EOS", [NumberFormatter displayStringFromNumber:@(self.model.assests_balance.doubleValue)]];
        }else if ([self.model.assestsName isEqualToString:@"oct"]){
        self.headerView.Assest_balance_Label.text = [NSString stringWithFormat:@"%@ OCT", [NumberFormatter displayStringFromNumber:@(self.model.assests_balance.doubleValue)]];
    }
    
    self.headerView.assest_value_label.text = [NSString stringWithFormat:@"≈%@ CNY", [NumberFormatter displayStringFromNumber:@(self.model.assests_balance.doubleValue * self.model.assests_price_cny.doubleValue)]];
    
    WS(weakSelf);
    [self.getSparklinesRequest getDataSusscess:^(id DAO, id data) {
        NSString *tendencyUrlStr ;
        if ([weakSelf.model.assestsName isEqualToString:@"EOS"]) {
            tendencyUrlStr = data[@"data"][@"sparkline_eos_png"];
        }else if ([weakSelf.model.assestsName isEqualToString:@"OCT"]){
            tendencyUrlStr = data[@"data"][@"sparkline_oct_png"];
        }
        UIImageView *imgView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tendencyUrlStr]]];
        imgView.image = img;
        imgView.frame = weakSelf.headerView.tendencyChartView.bounds;
        [weakSelf.headerView.tendencyChartView addSubview:imgView];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransactionRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    TransactionRecord *model = self.transactionRecordsService.dataSourceArray[indexPath.row];
    if ([self.model.assestsName isEqualToString:@"eos"]) {
       model = self.transactionRecordsService.eosTransactionDatasourceArray[indexPath.row];
    }else if ([self.model.assestsName isEqualToString:@"oct"]){
       model = self.transactionRecordsService.octTransactionDatasourceArray[indexPath.row];
    }
    cell.currentAccountName = self.currentAccountName;
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.assestsName isEqualToString:@"eos"]) {
        return self.transactionRecordsService.eosTransactionDatasourceArray.count;
    }else if ([self.model.assestsName isEqualToString:@"oct"]){
        return self.transactionRecordsService.octTransactionDatasourceArray.count;
    }
    return 0;
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

- (void)rightBtnDidClick {
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
    self.assestsShareDetailView.referencePriceLabel.text = [NSString stringWithFormat:@"¥%@", [NumberFormatter displayStringFromNumber:@(self.model.assests_price_cny.doubleValue)]];
   
    if ([self.model.assests_price_change_in_24 hasPrefix:@"-"]) {
        self.assestsShareDetailView.priceChangeIn24hLabel.text = [NSString stringWithFormat:@"%@%%", self.model.assests_price_change_in_24];
    }else{
        self.assestsShareDetailView.priceChangeIn24hLabel.text = [NSString stringWithFormat:@"+%@%%", self.model.assests_price_change_in_24];
    }
    self.assestsShareDetailView.totalMarketCapitalizationLabel.text = [NSString stringWithFormat:@"¥%@", [NumberFormatter displayStringFromNumber:@(self.model.assests_market_cap_cny.doubleValue)]];
}

- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}

- (void)cancleShareAssestsDetail{
    [self.shareBaseView removeFromSuperview];
}

// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    ShareModel *model = [[ShareModel alloc] init];
    if ([self.model.assestsName isEqualToString:@"eos"]) {
        model.title = NSLocalizedString(@"EOS最新咨询详情", nil);
        model.imageName = @"eos_avatar";
    }else if ([self.model.assestsName isEqualToString:@"oct"]){
        model.title = NSLocalizedString(@"OCT最新咨询详情", nil);
        model.imageName = @"oct_avatar";
    }
    NSString *priceChange ;
    if ([self.model.assests_price_change_in_24 hasPrefix:@"-"]) {
        priceChange = [NSString stringWithFormat:@"%@%%", self.model.assests_price_change_in_24];
    }else{
        priceChange = [NSString stringWithFormat:@"+%@%%", self.model.assests_price_change_in_24];
    }
    model.detailDescription = [NSString stringWithFormat:NSLocalizedString(@"参考价格%@\n24小时涨跌幅%@\n总市值¥%@\n", nil), [NSString stringWithFormat:@"¥%@", [NumberFormatter displayStringFromNumber:@(self.model.assests_price_cny.doubleValue)]], priceChange,[NumberFormatter displayStringFromNumber:@(self.model.assests_market_cap_cny.doubleValue)]];
    model.webPageUrl = @"https://pocketeos.com";
    NSLog(@"%@", platformName);
    if ([platformName isEqualToString:@"wechat_friends"]) {
        [[SocialManager socialManager] wechatShareToScene:0 withShareModel:model];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        [[SocialManager socialManager] wechatShareToScene:1 withShareModel:model];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [[SocialManager socialManager] qqShareToScene:0 withShareModel:model];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [[SocialManager socialManager] qqShareToScene:1 withShareModel:model];
    }
}

// AssestsDetailHeaderView Delegate
- (void)transferBtnDidClick{
    TransferViewController *vc = [[TransferViewController alloc] init];
    vc.accountName = self.accountName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)recieveBtnDidClick{
    RecieveViewController *vc = [[RecieveViewController alloc] init];
    vc.accountName = self.accountName;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)redPacketBtnDidClick{
    RedPacketViewController *vc = [[RedPacketViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//AssestDetailFooterViewDelegate
- (void)assestsDetailFooterViewDidClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        TransferViewController *vc = [[TransferViewController alloc] init];
        vc.accountName = self.accountName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.accountName = self.accountName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){
        RedPacketViewController *vc = [[RedPacketViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    [self.mainTableView.mj_footer resetNoMoreData];
    [self.transactionRecordsService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshing];
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
    [self.transactionRecordsService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
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
