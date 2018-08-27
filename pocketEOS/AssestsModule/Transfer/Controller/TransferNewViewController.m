//
//  TransferNewViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "TransferNewViewController.h"
#import "TransferHeaderView.h"
#import "NavigationView.h"
#import "Assest.h"
#import "ScanQRCodeViewController.h"
#import "ChangeAccountViewController.h"
#import "TransferService.h"
#import "TransactionResult.h"
#import "AssestsMainService.h"
#import "Account.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "TransactionRecordsService.h"
#import "TransactionRecordTableViewCell.h"
#import "TransactionRecord.h"
#import "Follow.h"
#import "WalletAccount.h"
#import "TransferAbi_json_to_bin_request.h"
#import "Get_token_info_service.h"
#import "TransferRecordsViewController.h"

@interface TransferNewViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, TransferHeaderViewDelegate, ChangeAccountViewControllerDelegate, UITextFieldDelegate, TransferServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) TransferHeaderView *headerView;
@property(nonatomic, strong) TransferService *mainService;
@property(nonatomic, strong) Get_token_info_service *get_token_info_service;
@property(nonatomic, strong) AssestsMainService *assestsMainService;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) TransactionRecordsService *transactionRecordsService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic , strong) TokenInfo *currentToken;
@end

@implementation TransferNewViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资产转账", nil) rightBtnTitleName:NSLocalizedString(@"转账记录", nil) delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (TransferHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 430);
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

- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
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

- (NSMutableArray *)get_token_info_service_data_array{
    if (!_get_token_info_service_data_array) {
        _get_token_info_service_data_array = [[NSMutableArray alloc] init];
    }
    return _get_token_info_service_data_array;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置默认的转账账号及资产
    if (self.transferModel || self.recieveTokenModel) {
        if (self.transferModel) {
            self.headerView.nameTF.text = self.transferModel.account_name;
            self.headerView.amountTF.text = self.transferModel.money;
            self.currentAssestsType = self.transferModel.coin;
        }else if (self.recieveTokenModel){
            self.headerView.nameTF.text = self.recieveTokenModel.account_name;
            self.headerView.amountTF.text = self.recieveTokenModel.quantity;
            self.headerView.memoTV.text = self.recieveTokenModel.memo;
            self.currentAssestsType = self.recieveTokenModel.token;
        }
        self.headerView.assestChooserLabel.text = self.currentAssestsType;
        for (TokenInfo *token in self.get_token_info_service_data_array) {
            if ([token.token_symbol isEqualToString:self.currentAssestsType]) {
                self.currentToken = token;
            }
        }
        
    }else{
        if (self.get_token_info_service_data_array.count > 0) {
        self.currentToken = self.get_token_info_service_data_array[0];
        self.currentAssestsType = self.currentToken.token_symbol;
        self.headerView.assestChooserLabel.text = self.currentToken.token_symbol;
        }else{
            [TOASTVIEW showWithText: NSLocalizedString(@"当前账号未添加资产", nil)];
            return;
        }
    }
    [self requestRate];
    [MobClick beginLogPageView:@"pe转账"]; //("Pagename"为页面名称，可自定义)
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"pe转账"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    
    [self requestRichList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.nameTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.amountTF];
}

- (void)requestRichList{
    self.mainService.richListRequest.uid = CURRENT_WALLET_UID;
    [self.mainService getRichlistAccount:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"getRichlistAccountSuccess");
        }
    }];
}

- (void)requestRate{
    WS(weakSelf);
    self.mainService.getRateRequest.coinmarket_id = VALIDATE_STRING(self.currentToken.coinmarket_id);
    [self.mainService get_rate:^(GetRateResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.getRateResult = result;
            [weakSelf configHeaderView];
        }
    }];
}

- (void)requestTokenInfoDataArray{
    self.get_token_info_service.get_token_info_request.accountName = CURRENT_ACCOUNT_NAME;
    WS(weakSelf);
    [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
            if (weakSelf.get_token_info_service_data_array.count > 0) {
                weakSelf.currentToken = weakSelf.get_token_info_service_data_array[0];
                weakSelf.currentAssestsType = weakSelf.currentToken.token_symbol;
                weakSelf.headerView.assestChooserLabel.text = weakSelf.currentToken.token_symbol;
                [weakSelf requestRate];
            }else{
                [TOASTVIEW showWithText: NSLocalizedString(@"当前账号未添加资产", nil)];
                return;
            }
        }
    }];
}

- (void)configHeaderView{
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
    self.headerView.assest_balanceLabel.text = [NSString stringWithFormat:@"%@ %@", [NumberFormatter displayStringFromNumber:@(self.currentToken.balance.doubleValue)], self.currentToken.token_symbol];
    self.headerView.assest_balance_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:self.currentToken.balance_cny.doubleValue]]];
//    self.headerView.amount_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
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
    if (IsStrEmpty(self.currentToken.coinmarket_id)  ) {
        self.headerView.amount_ConvertLabel.text = [NSString stringWithFormat:@"≈0CNY"];
    }else{
        self.headerView.amount_ConvertLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.getRateResult.data.price_cny.doubleValue)]];
        
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    TransferRecordsViewController *vc = [[TransferRecordsViewController alloc] init];
    vc.get_token_info_service_data_array = self.get_token_info_service_data_array;
    vc.currentToken = self.currentToken;
    vc.from = CURRENT_ACCOUNT_NAME;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectAssestsBtnDidClick:(UIButton *)sender {
    WS(weakSelf);
    [self.view endEditing:YES];
    NSMutableArray *assestsArr = [NSMutableArray array];
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    for (int i = 0 ; i < self.get_token_info_service_data_array.count; i++) {
        TokenInfo *token = self.get_token_info_service_data_array[i];
        if ([token.token_symbol isEqualToString:self.currentToken.token_symbol]) {
            builder.defaultIndex = i;
        }
        [assestsArr addObject: token.token_symbol];
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:assestsArr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.currentAssestsType = VALIDATE_STRING(strings[0]);
        weakSelf.headerView.assestChooserLabel.text = weakSelf.currentAssestsType;
        for (TokenInfo *token in self.get_token_info_service_data_array) {
            if ([token.token_symbol isEqualToString:self.currentAssestsType]) {
                weakSelf.currentToken = token;
            }
        }
        [weakSelf requestRate];
    }cancel:^{
        NSLog(@"user cancled");
    }];
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
    [self removeLoginPasswordView];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    if (IsNilOrNull(self.currentToken)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"当前账号未添加资产", nil)];
        return;
    }
    self.transferAbi_json_to_bin_request.code = self.currentToken.contract_name;
    
    if ([self.currentToken.balance isEqualToString:@"0"] || ( self.currentToken.balance.doubleValue  < self.headerView.amountTF.text.doubleValue)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"余额不足", nil)];
        [self removeLoginPasswordView];
        return;
    }else{
        if ([NSString getDecimalStringPercisionWithDecimalStr:self.currentToken.balance] == 3) {
            self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.3f %@", self.headerView.amountTF.text.doubleValue, self.currentToken.token_symbol];
        }else if ([NSString getDecimalStringPercisionWithDecimalStr:self.currentToken.balance] == 4){
            self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f %@", self.headerView.amountTF.text.doubleValue, self.currentToken.token_symbol];
        }
    }
    
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = CURRENT_ACCOUNT_NAME;
    self.transferAbi_json_to_bin_request.to = self.headerView.nameTF.text;
    self.transferAbi_json_to_bin_request.memo = self.headerView.memoTV.text;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText:result.message];
            [weakSelf cancleBtnDidClick:nil];
            return ;
        }
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        
        weakSelf.mainService.action = ContractAction_TRANSFER;
        weakSelf.mainService.code = weakSelf.currentToken.contract_name;
        weakSelf.mainService.sender = CURRENT_ACCOUNT_NAME;
#pragma mark -- [@"data"]
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf removeLoginPasswordView];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)removeLoginPasswordView{
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}
@end

