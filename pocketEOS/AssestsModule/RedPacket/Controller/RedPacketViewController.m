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
#import "RedPacketDetailViewController.h"
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
#import "TransferAbi_json_to_bin_request.h"

@interface RedPacketViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, RedPacketHeaderViewDelegate, PopUpWindowDelegate, TransferServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
@property(nonatomic, strong) RedPacketHeaderView *headerView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) NSString *currentAssestsType;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) GetRateRequest *getRateRequest;
@property(nonatomic , strong) RedPacket *redPacket;
@property(nonatomic , strong) RedpacketService *mainService;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@end

@implementation RedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"发红包", nil)rightBtnImgName:@"" delegate:self];
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
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 505);
        _headerView.delegate = self;
    }
    return _headerView;
}
- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
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

- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentAccountName = self.accountName;
    // 设置默认的转账账号及资产
    self.headerView.accountChooserLabel.text = self.currentAccountName;
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
    
    [self requestRedPacketRecords];
    [MobClick beginLogPageView:@"pe发红包"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"pe发红包"];
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

- (void)requestRedPacketRecords{
    self.mainService.getRedPacketRecordRequest.uid = CURRENT_WALLET_UID;
    self.mainService.getRedPacketRecordRequest.account = self.currentAccountName;
    self.mainService.getRedPacketRecordRequest.type = self.currentAssestsType;
    [self loadNewData];
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
            weakSelf.headerView.tipLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
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
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RedPacketRecord *model = self.mainService.dataSourceArray[indexPath.row];
    if (model.isSend == YES) {
//        [model.residueCount isEqualToNumber:@0] ? NSLocalizedString(@"全部被领取", nil): [NSString stringWithFormat: @"%@%ld%@", NSLocalizedString(@"已被", nil), model.packetCount.integerValue - model.residueCount.integerValue,NSLocalizedString(@"人领取", nil) ]
        NSString *str;
        if ([model.residueCount isEqualToNumber:@0]) {
            str = NSLocalizedString(@"全部被领取", nil);
        }else{
            str = [NSString stringWithFormat: @"%@%ld%@", NSLocalizedString(@"已被", nil), model.packetCount.integerValue - model.residueCount.integerValue,NSLocalizedString(@"人领取", nil) ];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@, %@",NSLocalizedString(@"发送", nil), model.amount, NSLocalizedString(@"个", nil),model.type, NSLocalizedString(@"给", nil),model.packetCount,NSLocalizedString(@"个人", nil), str];
        
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"领取", nil), model.amount, NSLocalizedString(@"个", nil), model.type];
    }
//    cell.textLabel.frame = CGRectMake(MARGIN_20, MARGIN_20, SCREEN_WIDTH-(MARGIN_20*2), 21);
    cell.detailTextLabel.text =model.createTime;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = HEXCOLOR(0x2A2A2A);
    cell.detailTextLabel.textColor = HEXCOLOR(0xB0B0B0);
    cell.bottomLineView.hidden = NO;
    if (indexPath.row == self.mainService.dataSourceArray.count-1) {
        cell.bottomLineView.hidden = YES;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketDetailViewController *vc = [[RedPacketDetailViewController alloc] init];
    RedPacketModel *model = [[RedPacketModel alloc] init];
    model.from = self.currentAccountName;
    model.count = self.headerView.redPacketCountTF.text;
    model.memo =   self.headerView.descriptionTextView.text;
    model.amount = self.headerView.amountTF.text;
    
    RedPacketRecord *record = self.mainService.dataSourceArray[indexPath.row];
    model.redPacket_id = record.redPacket_id;
    model.verifystring = record.verifyString;
    model.amount = record.amount;
    model.isSend = record.isSend;
    model.coin = record.type;
    vc.redPacketModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71.5;
}
- (void)textFieldChange:(NSNotification *)notification {
    BOOL isCanSubmit = (self.headerView.amountTF.text.length != 0 && self.headerView.redPacketCountTF.text.length != 0);
    if (isCanSubmit) {
        [self.headerView.sendRedpacketBtn setBackgroundColor: HEXCOLOR(0xD82919)];
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
    if (IsStrEmpty(self.headerView.amountTF.text)) {
        [TOASTVIEW showWithText:@"请填写资产数量!"];
        return;
    }
    if (IsStrEmpty(self.headerView.redPacketCountTF.text)) {
        [TOASTVIEW showWithText:@"请填写红包个数!"];
        return;
    }
    [self.view addSubview:self.loginPasswordView];
}


// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    
    self.mainService.sendRedpacketRequest.uid = CURRENT_WALLET_UID;
    self.mainService.sendRedpacketRequest.account = self.currentAccountName;
    self.mainService.sendRedpacketRequest.amount = @(self.headerView.amountTF.text.doubleValue);
    self.mainService.sendRedpacketRequest.packetCount = @(self.headerView.redPacketCountTF.text.integerValue);
    self.mainService.sendRedpacketRequest.type = self.currentAssestsType;
    
    WS(weakSelf);
    [self.mainService sendRedPacket:^(RedPacket *result, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"redpacket_id:%@", result.redpacket_id);
            weakSelf.redPacket = result;
            // push transaction
            [weakSelf pushTransaction];
        }
    }];
}




- (void)pushTransaction{
    if ([self.currentAssestsType isEqualToString:@"EOS"]) {
        self.transferAbi_json_to_bin_request.code = ContractName_EOSIOTOKEN;
        self.transferService.code = ContractName_EOSIOTOKEN;
        self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f EOS", self.headerView.amountTF.text.doubleValue];
    }else if ([self.currentAssestsType isEqualToString:@"OCT"]){
        self.transferAbi_json_to_bin_request.code = ContractName_OCTOTHEMOON;
        self.transferService.code = ContractName_OCTOTHEMOON;
        self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f OCT", self.headerView.amountTF.text.doubleValue];
    }
    
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = self.currentAccountName;
    self.transferAbi_json_to_bin_request.to = RedPacketReciever;
    self.transferAbi_json_to_bin_request.memo = self.headerView.descriptionTextView.text;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.currentAccountName];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_TRANSFER;
        weakSelf.transferService.sender = weakSelf.currentAccountName;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
        weakSelf.loginPasswordView = nil;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}



// TransferServiceDelegate
- (void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        NSLog(NSLocalizedString(@"转账到eosredpacket成功!", nil));
        ForwardRedPacketViewController *vc = [[ForwardRedPacketViewController alloc] init];
        RedPacketModel *model = [[RedPacketModel alloc] init];
        model.from = self.currentAccountName;
        model.amount = self.headerView.amountTF.text;
        model.count = self.headerView.redPacketCountTF.text;
        model.coin = self.currentAssestsType;
        model.memo =  IsStrEmpty(self.headerView.descriptionTextView.text) ? self.headerView.descriptionTextView.text : @"";
        model.amount = self.headerView.amountTF.text;
        model.transactionId = result.transaction_id;
        model.redPacket_id = self.redPacket.redpacket_id;
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
        self.mainService.getRedPacketRecordRequest.type = self.currentAssestsType;
        [self buidDataSource];
        [self requestRedPacketRecords];
    }else if ([sender isKindOfClass:[AccountInfo class]]){
        self.headerView.accountChooserLabel.text = [(AccountInfo *)sender account_name];
        self.currentAccountName = [(AccountInfo *)sender account_name];
        [self requestRedPacketRecords];
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
//- (void)loadMoreData
//{
//    WS(weakSelf);
//    [self.mainService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
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
//}


@end
