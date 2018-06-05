//
//  RedPacketViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketHeaderView.h"
#import "NavigationView.h"
#import "PopUpWindow.h"
#import "ForwardRedPacketViewController.h"
#import "Assest.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "Account.h"
#import "GetRateRequest.h"
#import "RedPacketModel.h"
#import "RedpacketService.h"
#import "RedPacket.h"
#import "TransferService.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "RedPacketRecordResult.h"
#import "RedPacketRecord.h"

@interface RedPacketViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, RedPacketHeaderViewDelegate, PopUpWindowDelegate, TransferServiceDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
@property(nonatomic, strong) RedPacketHeaderView *headerView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) NSString *currentAssestsType;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) GetRateRequest *getRateRequest;
@property(nonatomic , strong) RedpacketService *mainService;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@end

@implementation RedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"发红包" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (PopUpWindow *)popUpWindow{
    if (!_popUpWindow) {
        _popUpWindow = [[PopUpWindow alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50 ))];
        _popUpWindow.delegate = self;
    }
    return _popUpWindow;
}

- (RedPacketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RedPacketHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 489);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (GetRateRequest *)getRateRequest{
    if (!_getRateRequest) {
        _getRateRequest = [[GetRateRequest alloc] init];
    }
    return _getRateRequest;
}

- (RedpacketService *)mainService{
    if (!_mainService) {
        _mainService = [[RedpacketService alloc] init];
    }
    return _mainService;
}

- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}

- (TransactionRecordsService *)transactionRecordsService{
    if (!_transactionRecordsService) {
        _transactionRecordsService = [[TransactionRecordsService alloc] init];
    }
    return _transactionRecordsService;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentAccountName = self.accountName;
    self.currentAssestsType = @"EOS";
    // 设置默认的转账账号及资产
    self.headerView.accountChooserLabel.text = self.currentAccountName;
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
    self.transactionRecordsService.getTransactionRecordsRequest.account_name = self.accountName;
    [self loadNewData];
//    [self textFieldChange:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.currentAssestsType = @"EOS";
    [self buidDataSource];
    
    [self loadAllBlocks];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.amountTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.redPacketCountTF];
}

- (void)buidDataSource{
    WS(weakSelf);
    if ([self.currentAssestsType isEqualToString:@"EOS"]) {
        self.getRateRequest.coinmarket_id = @"eos";
    }else if ([self.currentAssestsType isEqualToString:@"OCT"]){
        self.getRateRequest.coinmarket_id = @"oraclechain";
    }
    [self.getRateRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            weakSelf.getRateResult = [GetRateResult mj_objectWithKeyValues:data];
            
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.popUpWindow setOnBottomViewDidClick:^{
        [weakSelf removePopUpWindow];
    }];
    
}


// UITableViewDelegate && DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RedPacketRecord *model = self.mainService.dataSourceArray[indexPath.row];
    if (model.isSend == YES) {
        cell.textLabel.text = [NSString stringWithFormat:@"发送%@个%@给%@个人，%@", model.amount, model.type, model.packetCount, model.residueCount == 0 ? @"全部被领取" : [NSString stringWithFormat: @"剩余%@个未被领取", model.residueCount]];
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"领取%@个%@", model.amount, model.type];
    }
    cell.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = HEXCOLOR(0x2A2A2A);
    cell.detailTextLabel.text =model.createTime;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = HEXCOLOR(0xB0B0B0);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainService getRedPacketDetail:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"getRedPacketDetailSuccess!");
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71.5;
}
- (void)textFieldChange:(NSNotification *)notification {
    BOOL isCanSubmit = (self.headerView.amountTF.text.length != 0 && self.headerView.redPacketCountTF.text.length != 0);
    if (isCanSubmit) {
        self.headerView.sendRedpacketBtn.lee_theme
        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
    } else {
        [self.headerView.sendRedpacketBtn setBackgroundColor: HEXCOLOR(0xCCCCCC)];
    }
    self.headerView.sendRedpacketBtn.enabled = isCanSubmit;
    
    if ([self.headerView.amountTF isFirstResponder]) {
        self.headerView.tipLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
    }
    
}

// NavigationView delegate
- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


// headerViewDelegate
- (void)selectAccountBtnDidClick:(UIButton *)sender {
    [self.view addSubview:self.popUpWindow];
    NSMutableArray *accountArr =  [[AccountsTableManager accountTable] selectAccountTable];
    _popUpWindow.type = PopUpWindowTypeAccount;
    for (AccountInfo *model in accountArr) {
        if ([model.account_name isEqualToString:self.currentAccountName]) {
            model.selected = YES;
        }
    }
    [_popUpWindow updateViewWithArray:accountArr title:@""];
}

- (void)selectAssestsBtnDidClick:(UIButton *)sender {
    [self.view addSubview:self.popUpWindow];
    Assest *eosAssest = [[Assest alloc] init];
    eosAssest.assetName = @"EOS";
    Assest *octAssest = [[Assest alloc] init];
    octAssest.assetName = @"OCT";
    _popUpWindow.type = PopUpWindowTypeAssest;
    NSArray *assestsArr = @[eosAssest , octAssest];
    for (Assest *model in assestsArr) {
        if ([model.assetName isEqualToString:self.currentAssestsType]) {
            model.selected = YES;
        }
    }
    [_popUpWindow updateViewWithArray:assestsArr title:@""];
}

-(void)sendRedPacket:(UIButton *)sender{
    [TOASTVIEW showWithText:@"EOS主网上线之后，该功能开放!"];
//    self.mainService.sendRedpacketRequest.uid = CURRENT_WALLET_UID;
//    self.mainService.sendRedpacketRequest.account = self.currentAccountName;
//    self.mainService.sendRedpacketRequest.amount = @(self.headerView.amountTF.text.integerValue);
//    self.mainService.sendRedpacketRequest.packetCount = @(self.headerView.redPacketCountTF.text.integerValue);
//    self.mainService.sendRedpacketRequest.type = self.currentAssestsType;
//
//    WS(weakSelf);
//    [self.mainService sendRedPacket:^(RedPacket *result, BOOL isSuccess) {
//        if (isSuccess) {
//            NSLog(@"redpacket_id:%@", result.redpacket_id);
//            // push transaction
//            AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.currentAccountName];
//            weakSelf.transferService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
//            weakSelf.transferService.action = @"transfer";
////            weakSelf.transferService.memo = weakSelf.headerView.descriptionTextView.text;
////            weakSelf.transferService.quantity =  self.headerView.amountTF.text ;
////            weakSelf.transferService.receiver = @"oc.redpacket";
//            weakSelf.transferService.sender = weakSelf.currentAccountName;
//            weakSelf.transferService.code = [weakSelf.currentAssestsType lowercaseString];
//            [weakSelf.transferService pushTransaction];
//        }
//    }];
//
}


// TransferServiceDelegate
- (void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        NSLog(@"转账到oc.redpacket成功!" );
        ForwardRedPacketViewController *vc = [[ForwardRedPacketViewController alloc] init];
        RedPacketModel *model = [[RedPacketModel alloc] init];
        model.amount = self.headerView.amountTF.text;
        model.count = self.headerView.redPacketCountTF.text;
        model.coin = self.currentAssestsType;
        model.memo =  IsStrEmpty(self.headerView.descriptionTextView.text) ? self.headerView.descriptionTextView.text : @"";
        model.amount = self.headerView.amountTF.text;
        vc.redPacketModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}

- (void)removePopUpWindow{
    [self.popUpWindow removeFromSuperview];
}

// PopUpWindowDelegate
- (void )popUpWindowdidSelectItem:(id)sender{
    if ([sender isKindOfClass: [Assest class]]) {
        self.headerView.assestChooserLabel.text = [(Assest *)sender assetName];
        self.currentAssestsType = [(Assest *)sender assetName];
    }else if ([sender isKindOfClass:[AccountInfo class]]){
        self.headerView.accountChooserLabel.text = [(AccountInfo *)sender account_name];
        self.currentAccountName = [(AccountInfo *)sender account_name];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
//    WS(weakSelf);
//    [self.transactionRecordsService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
//        if (isSuccess) {
//            // 刷新表格
//            [weakSelf.mainTableView reloadData];
//            if ([dataCount isEqualToNumber:@0]) {
//                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                // 拿到当前的下拉刷新控件，结束刷新状态
//                [weakSelf.mainTableView.mj_footer endRefreshing];
//            }
//        }else{
//            [weakSelf.mainTableView.mj_header endRefreshing];
//            [weakSelf.mainTableView.mj_footer endRefreshing];
//        }
//    }];
}


@end
