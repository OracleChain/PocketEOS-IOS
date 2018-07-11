//
//  TransferViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "TransferViewController.h"
#import "TransferHeaderView.h"
#import "NavigationView.h"
#import "PopUpWindow.h"
#import "Assest.h"
#import "ScanQRCodeViewController.h"
#import "ChangeAccountViewController.h"
#import "TransferService.h"
#import "TransactionResult.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "AssestsMainService.h"
#import "AccountResult.h"
#import "Account.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "TransactionRecord.h"
#import "Follow.h"
#import "WalletAccount.h"
#import "TransferAbi_json_to_bin_request.h"

@interface TransferViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, TransferHeaderViewDelegate, PopUpWindowDelegate, ChangeAccountViewControllerDelegate, UITextFieldDelegate, TransferServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PopUpWindow *popUpWindow;
@property(nonatomic, strong) TransferHeaderView *headerView;
@property(nonatomic, strong) TransferService *mainService;
@property(nonatomic, strong) AssestsMainService *assestsMainService;
@property(nonatomic, strong) NSString *currentAccountName;

@property(nonatomic, strong) AccountResult *accountResult;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@end

@implementation TransferViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资产转账", nil)rightBtnImgName:@"scan_black" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.rightBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"scan_black"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"scan"], UIControlStateNormal);
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

- (TransferHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 580);
        _headerView.delegate = self;
        _headerView.amountTF.delegate = self;
        _headerView.nameTF.delegate = self;
    }
    return _headerView;
}


- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}

- (TransactionRecordsService *)transactionRecordsService{
    if (!_transactionRecordsService) {
        _transactionRecordsService = [[TransactionRecordsService alloc] init];
    }
    return _transactionRecordsService;
}

- (AssestsMainService *)assestsMainService{
    if (!_assestsMainService) {
        _assestsMainService = [[AssestsMainService alloc] init];
    }
    return _assestsMainService;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
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
    // 设置默认的转账账号及资产
    if (self.transferModel) {
        
        // 从扫描二维码页面过来
        self.headerView.nameTF.text = self.transferModel.account_name;
        self.headerView.amountTF.text = self.transferModel.money;
        self.currentAssestsType = self.transferModel.coin;
        self.headerView.assestChooserLabel.text = self.transferModel.coin;
        
        NSArray *accountNameArr = [[AccountsTableManager accountTable] selectAllNativeAccountName];
        if (accountNameArr > 0) {
            NSString *mainAccountName = [[AccountsTableManager accountTable] selectAllNativeAccountName][0];
            self.accountName = mainAccountName;
        }
        
    }else{
        if (!IsStrEmpty(self.currentAssestsType)) {
            self.headerView.assestChooserLabel.text = self.currentAssestsType;
        }else{
            // default
            self.currentAssestsType = @"EOS";
            self.headerView.assestChooserLabel.text = @"EOS";
        }
    }
    [self textFieldChange:nil];
    self.currentAccountName = self.accountName;
    self.headerView.accountChooserLabel.text = self.accountName;
    [self buidDataSource];
    
    self.transactionRecordsService.getTransactionRecordsRequest.from = self.accountName;
    NSString *contractName;
    if ([self.currentAssestsType isEqualToString:@"EOS" ]) {
        contractName = ContractName_EOSIOTOKEN;
    }else if ([self.currentAssestsType isEqualToString:@"OCT" ]){
        contractName = ContractName_OCTOTHEMOON;
    }
    self.transactionRecordsService.getTransactionRecordsRequest.symbols = [NSMutableArray arrayWithObjects:@{@"symbolName":@"EOS"  , @"contractName": ContractName_EOSIOTOKEN },@{@"symbolName": @"OCT"  , @"contractName": ContractName_OCTOTHEMOON }, nil];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.nameTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.amountTF];
    self.transactionRecordsService.getTransactionRecordsRequest.from = self.accountName;
    NSString *contractName;
    if (!IsStrEmpty(self.currentAssestsType)) {
        self.headerView.assestChooserLabel.text = self.currentAssestsType;
    }else{
        // default
        self.currentAssestsType = @"EOS";
        self.headerView.assestChooserLabel.text = @"EOS";
    }
    if ([self.currentAssestsType isEqualToString:@"EOS"]){
        contractName = ContractName_EOSIOTOKEN;
    }else if ([self.currentAssestsType isEqualToString:@"OCT"]){
        contractName = ContractName_OCTOTHEMOON;
    }
    self.transactionRecordsService.getTransactionRecordsRequest.symbols = [NSMutableArray arrayWithObjects:@{@"symbolName":@"EOS"  , @"contractName": ContractName_EOSIOTOKEN },@{@"symbolName": @"OCT"  , @"contractName": ContractName_OCTOTHEMOON }, nil];
    
    self.mainService.richListRequest.uid = CURRENT_WALLET_UID;
    [self.mainService getRichlistAccount:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"getRichlistAccountSuccess" );
        }
    }];
}

- (void)buidDataSource{
    WS(weakSelf);
    dispatch_group_t group = dispatch_group_create();
    // getRate
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        if ([weakSelf.currentAssestsType isEqualToString:@"EOS"]) {
            weakSelf.mainService.getRateRequest.coinmarket_id = @"eos";
        }else if ([weakSelf.currentAssestsType isEqualToString:@"OCT"]){
            weakSelf.mainService.getRateRequest.coinmarket_id = @"oraclechain";
        }
        [weakSelf.mainService get_rate:^(GetRateResult *result, BOOL isSuccess) {
            if (isSuccess) {
                 weakSelf.getRateResult = result;
                 dispatch_group_leave(group);
            }
        }];
    });
    
    // getAccountAsset
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0 ), ^{
        if (IsNilOrNull(weakSelf.currentAccountName)) {
            return;
        }
        weakSelf.assestsMainService.getAccountAssetRequest.name = weakSelf.currentAccountName;
        [weakSelf.assestsMainService get_account_asset:^(AccountResult *result, BOOL isSuccess) {
            if (isSuccess) {
                weakSelf.accountResult = result;
                if ([weakSelf.currentAssestsType isEqualToString:@"EOS"]) {
                    
                    weakSelf.headerView.assest_balanceLabel.text = [NSString stringWithFormat:@"%@ EOS", [NumberFormatter displayStringFromNumber:@(result.data.eos_balance.doubleValue)]];
                }else if ([weakSelf.currentAssestsType isEqualToString:@"OCT"]){
                    weakSelf.headerView.assest_balanceLabel.text = [NSString stringWithFormat:@"%@ OCT", [NumberFormatter displayStringFromNumber:@(result.data.oct_balance.doubleValue)]];
                }
                dispatch_group_leave(group);
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([weakSelf.currentAssestsType isEqualToString:@"EOS"]) {
            
            weakSelf.headerView.assest_balance_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:weakSelf.getRateResult.data.price_cny.doubleValue * weakSelf.accountResult.data.eos_balance.doubleValue]]];
        }else if ([weakSelf.currentAssestsType isEqualToString:@"OCT"]){
            
            weakSelf.headerView.assest_balance_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:weakSelf.getRateResult.data.price_cny.doubleValue * weakSelf.accountResult.data.oct_balance.doubleValue]]];
        }
    });
}

- (void)loadAllBlocks{
    WS(weakSelf);
    [self.popUpWindow setOnBottomViewDidClick:^{
        
        [weakSelf removePopUpWindow];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransactionRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    TransactionRecord *model = self.transactionRecordsService.sendTransactionDatasourceArray[indexPath.row];
    cell.currentAccountName = self.currentAccountName;
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transactionRecordsService.sendTransactionDatasourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}


- (void)textFieldChange:(NSNotification *)notification {
    BOOL isCanSubmit = (self.headerView.nameTF.text.length != 0 && self.headerView.amountTF.text.length != 0);
    if (isCanSubmit) {

        self.headerView.transferBtn.lee_theme
        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
    } else {
        self.headerView.transferBtn.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xCCCCCC))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
     
        
    }
    self.headerView.transferBtn.enabled = isCanSubmit;
    
    if ([self.headerView.amountTF isFirstResponder]) {
        self.headerView.amount_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
    }
    
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


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

- (void)contactBtnDidClick:(UIButton *)sender {
    ChangeAccountViewController *vc = [[ChangeAccountViewController alloc] init];
    NSMutableArray *temp = [NSMutableArray array];
    for (Follow *follow in self.mainService.richListDataArray) {
        WalletAccount *walletAccount = [[WalletAccount alloc] init];
        walletAccount.eosAccountName = follow.displayName;
        [temp addObject:walletAccount];
    }
    vc.dataArray = temp;
    vc.changeAccountDataArrayType = ChangeAccountDataArrayTypeNetworking;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//ChangeAccountViewControllerDelegate
-(void)changeAccountCellDidClick:(NSString *)name{
    NSLog(@"%@" ,name);
    self.headerView.nameTF.text = name;
}

- (void)transferBtnDidClick:(UIButton *)sender {
    if (IsStrEmpty(self.headerView.nameTF.text)) {
        [TOASTVIEW showWithText:@"收币人不能为空"];
        return;
    }
    if (IsStrEmpty(self.headerView.amountTF.text)) {
        [TOASTVIEW showWithText:@"请填写金额"];
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
    
    if ([self.currentAssestsType isEqualToString:@"EOS"]) {
        self.transferAbi_json_to_bin_request.code = ContractName_EOSIOTOKEN;
        self.mainService.code = ContractName_EOSIOTOKEN;
        self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f EOS", self.headerView.amountTF.text.doubleValue];
    }else if ([self.currentAssestsType isEqualToString:@"OCT"]){
        self.transferAbi_json_to_bin_request.code = ContractName_OCTOTHEMOON;
        self.mainService.code = ContractName_OCTOTHEMOON;
        self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f OCT", self.headerView.amountTF.text.doubleValue];

    }
    
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = self.currentAccountName;
    self.transferAbi_json_to_bin_request.to = self.headerView.nameTF.text;
    self.transferAbi_json_to_bin_request.memo = self.headerView.memoTV.text;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
        #pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.currentAccountName];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.mainService.action = ContractAction_TRANSFER;
        weakSelf.mainService.sender = weakSelf.currentAccountName;
        #pragma mark -- [@"data"]
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
        weakSelf.loginPasswordView = nil;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}


// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"转账成功", nil)];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
        self.transactionRecordsService.getTransactionRecordsRequest.from = [(AccountInfo *)sender account_name];
        
        [self loadNewData];
    }
    [self buidDataSource];
    
}



- (void)rightBtnDidClick {
    // 1. 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(NSLocalizedString(@"用户第一次同意了访问相机权限 - - %@", nil), [NSThread currentThread]);
                }else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(NSLocalizedString(@"用户第一次拒绝了访问相机权限 - - %@", nil), [NSThread currentThread]);
                }
                
                
            }];
        }else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)message:NSLocalizedString(@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关", nil)preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(NSLocalizedString(@"因为系统原因, 无法访问相册", nil));
        }
        
        
    }else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)message:NSLocalizedString(@"未检测到您的摄像头", nil)preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
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
