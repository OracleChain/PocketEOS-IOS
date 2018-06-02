//
//  RecieveViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RecieveViewController.h"
#import "RecieveHeaderView.h"
#import "NavigationView.h"
#import "PopUpWindow.h"
#import "RecieveQRCodeView.h"
#import "Assest.h"
#import "SGQRCode.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "TransactionRecord.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "TransferService.h"

@interface RecieveViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, RecieveHeaderViewDelegate, PopUpWindowDelegate, UITextFieldDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
@property(nonatomic, strong) RecieveHeaderView *headerView;
@property(nonatomic, strong) RecieveQRCodeView *recieveQRCodeView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) NSString *currentAssestsType;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) TransferService *transferService;
@end

@implementation RecieveViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"资产收款" rightBtnImgName:@"" delegate:self];
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

- (RecieveHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RecieveHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 323);
        _headerView.delegate = self;
        _headerView.amountTF.delegate = self;
    }
    return _headerView;
}

- (RecieveQRCodeView *)recieveQRCodeView{
    if (!_recieveQRCodeView) {
        _recieveQRCodeView = [[[NSBundle mainBundle] loadNibNamed:@"RecieveQRCodeView" owner:nil options:nil] firstObject];
        _recieveQRCodeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _recieveQRCodeView;
}

- (TransactionRecordsService *)transactionRecordsService{
    if (!_transactionRecordsService) {
        _transactionRecordsService = [[TransactionRecordsService alloc] init];
    }
    return _transactionRecordsService;
}

- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
    }
    return _transferService;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置默认的转账账号及资产
    self.headerView.accountChooserLabel.text = self.accountName;
    self.headerView.assestChooserLabel.text = @"EOS";
    self.currentAccountName = self.accountName;
    self.currentAssestsType = @"EOS";
   [self buidDataSource]; self.transactionRecordsService.getTransactionRecordsRequest.account_name = self.accountName;
    [self loadNewData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
//    [self.mainTableView.mj_header beginRefreshing];
    [self loadAllBlocks];
    self.transactionRecordsService.getTransactionRecordsRequest.account_name = self.accountName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.amountTF];
}

- (void)buidDataSource{
    WS(weakSelf);
    if ([self.currentAssestsType isEqualToString:@"EOS"]) {
        self.transferService.getRateRequest.coinmarket_id = @"eos";
    }else if ([self.currentAssestsType isEqualToString:@"OCT"]){
        self.transferService.getRateRequest.coinmarket_id = @"oraclechain";
    }
    [self.transferService get_rate:^(GetRateResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.getRateResult = result;
        }
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
    TransactionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransactionRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    TransactionRecord *model = self.transactionRecordsService.recieveTransactionDatasourceArray[indexPath.row];
    cell.currentAccountName = self.currentAccountName;
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transactionRecordsService.recieveTransactionDatasourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (void)textFieldChange:(NSNotification *)notification {
    BOOL isCanSubmit = self.headerView.amountTF.text.length != 0;
    if (isCanSubmit) {
        self.headerView.generateQRCodeBtn.lee_theme
        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
    } else {
       
        self.headerView.generateQRCodeBtn.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xCCCCCC))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
    }
    self.headerView.generateQRCodeBtn.enabled = isCanSubmit;
    if ([self.headerView.amountTF isFirstResponder]) {
        self.headerView.tipLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
    }
    
}


// navigationViewDelegate
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

- (void)createQRCodeBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.recieveQRCodeView];
    self.recieveQRCodeView.amountLabel.text = self.headerView.amountTF.text;
    self.recieveQRCodeView.assestTypeLabel.text = [NSString stringWithFormat:@"/ %@", self.currentAssestsType];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VALIDATE_STRING(self.accountName)  forKey:@"account_name"];
    [dic setObject:VALIDATE_STRING(self.currentAssestsType)  forKey:@"coin"];
    [dic setObject:VALIDATE_STRING(self.headerView.amountTF.text)  forKey:@"money"];
    [dic setObject:@"make_collections_QRCode"  forKey:@"type"];
    //钱包二维码
    NSString *QRCodeJsonStr = [dic mj_JSONString];
    self.recieveQRCodeView.recieveAssestsQRCodeImg.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:QRCodeJsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
}

- (void)removePopUpWindow{
    [self.popUpWindow removeFromSuperview];
}

- (void)removeRecieveQRCodeView{
    [self.recieveQRCodeView removeFromSuperview];
}


// PopUpWindowDelegate
- (void )popUpWindowdidSelectItem:(id)sender{
    if ([sender isKindOfClass: [Assest class]]) {
        self.headerView.assestChooserLabel.text = [(Assest *)sender assetName];
        self.currentAssestsType = [(Assest *)sender assetName];
    }else if ([sender isKindOfClass: [AccountInfo class] ]){
        self.headerView.accountChooserLabel.text = [(AccountInfo *)sender account_name];
        self.currentAccountName = [(AccountInfo *)sender account_name];
        self.transactionRecordsService.getTransactionRecordsRequest.account_name = [(AccountInfo *)sender account_name];
        [self loadNewData];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
