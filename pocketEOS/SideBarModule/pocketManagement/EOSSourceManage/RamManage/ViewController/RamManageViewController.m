//
//  RamManageViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RamManageViewController.h"
#import "RamManageHeaderView.h"
#import "GetRamHourChangerageRequest.h"
#import "GetCurrentRamPriceRequest.h"
#import "RamPriceModel.h"
#import "RamPriceResult.h"
#import "RamRateChange.h"
#import "Buy_ram_abi_json_to_bin_request.h"
#import "Sell_ram_abi_json_to_bin_request.h"
#import "TransferService.h"
#import "Get_table_rows_request.h"
#import "EOSResourceService.h"


@interface RamManageViewController ()<RamManageHeaderViewDelegate,TransferServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic , strong) RamManageHeaderView *headerView;
@property(nonatomic , strong) GetRamHourChangerageRequest *getRamHourChangerageRequest;
@property(nonatomic , strong) GetCurrentRamPriceRequest *getCurrentRamPriceRequest;
@property(nonatomic , strong) Buy_ram_abi_json_to_bin_request *buy_ram_abi_json_to_bin_request;
@property(nonatomic , strong) Sell_ram_abi_json_to_bin_request *sell_ram_abi_json_to_bin_request;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferService *transferService;
@property (nonatomic , strong) Get_table_rows_request *get_table_rows_request;
@property(nonatomic , strong) EOSResourceService *eosResourceService;
@end

@implementation RamManageViewController

- (RamManageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RamManageHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
        _headerView.delegate = self;
    }
    return _headerView;
}
- (GetRamHourChangerageRequest *)getRamHourChangerageRequest{
    if (!_getRamHourChangerageRequest) {
        _getRamHourChangerageRequest = [[GetRamHourChangerageRequest alloc] init];
    }
    return _getRamHourChangerageRequest;
}

- (GetCurrentRamPriceRequest *)getCurrentRamPriceRequest{
    if (!_getCurrentRamPriceRequest) {
        _getCurrentRamPriceRequest = [[GetCurrentRamPriceRequest alloc] init];
    }
    return _getCurrentRamPriceRequest;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

- (Sell_ram_abi_json_to_bin_request *)sell_ram_abi_json_to_bin_request{
    if (!_sell_ram_abi_json_to_bin_request) {
        _sell_ram_abi_json_to_bin_request = [[Sell_ram_abi_json_to_bin_request alloc] init];
    }
    return _sell_ram_abi_json_to_bin_request;
}

- (Buy_ram_abi_json_to_bin_request *)buy_ram_abi_json_to_bin_request{
    if (!_buy_ram_abi_json_to_bin_request) {
        _buy_ram_abi_json_to_bin_request = [[Buy_ram_abi_json_to_bin_request alloc] init];
    }
    return _buy_ram_abi_json_to_bin_request;
}

-(Get_table_rows_request *)get_table_rows_request{
    if (!_get_table_rows_request) {
        _get_table_rows_request = [[Get_table_rows_request alloc] init];
    }
    return _get_table_rows_request;
}

-(TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}

- (EOSResourceService *)eosResourceService{
    if (!_eosResourceService) {
        _eosResourceService = [[EOSResourceService alloc] init];
    }
    return _eosResourceService;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden: YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAVIGATIONBAR_HEIGHT);
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerView];
    
    [self.headerView updateViewWithEOSResourceResult:self.eosResourceResult];
    [self buildDataSource];
}

- (void)loadNewData{
    WS(weakSelf);
    self.eosResourceService.getAccountRequest.name = self.eosResourceResult.data.account_name;
    [self.eosResourceService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.eosResourceResult = result;
            [weakSelf.headerView updateViewWithEOSResourceResult:weakSelf.eosResourceResult];
        }
    }];
}

- (void)buildDataSource{
    WS(weakSelf);
    [self.getCurrentRamPriceRequest getDataSusscess:^(id DAO, id data) {
        RamPriceResult *result = [RamPriceResult mj_objectWithKeyValues:data];
        if (result.data.count > 0) {
            RamPriceModel *model = result.data[0];
            weakSelf.headerView.nowPriceLanel.text = [NSString stringWithFormat:@"%.4fEOS/KB", model.price.doubleValue];
        }
    } failure:^(id DAO, NSError *error) {
        
    }];
    
    
    [self.getRamHourChangerageRequest getDataSusscess:^(id DAO, id data) {
        RamRateChange *model = [RamRateChange mj_objectWithKeyValues:data];
        weakSelf.headerView.priceChangeLabel.text = [NSString stringWithFormat:@"%.2f%%(1h)", model.rateChange.doubleValue * 100];
        if ([model.rateChange hasPrefix:@"-"]) {
            weakSelf.headerView.indicateImageView.image = [UIImage imageNamed: @"downArrow_red"];
            weakSelf.headerView.priceChangeLabel.textColor = HEXCOLOR(0xF05F5F);
        }else{
            weakSelf.headerView.indicateImageView.image = [UIImage imageNamed: @"upArrow_green"];
            weakSelf.headerView.priceChangeLabel.textColor = HEXCOLOR(0x0BBF50);
        }
    } failure:^(id DAO, NSError *error) {
        
    }];
    
    
}



//RamManageHeaderViewDelegate
- (void)ramManageHeaderViewConfirmStakeBtnDidClick{
    
    if (IsStrEmpty(self.headerView.eosAmountTF.text)) {
        [TOASTVIEW showWithText: NSLocalizedString(@"输入不能为空!", nil)];
        return;
    }
    
    if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionBuyRam) {
        if (self.headerView.eosAmountTF.text.doubleValue > self.eosResourceResult.data.core_liquid_balance.doubleValue ) {
            [TOASTVIEW showWithText: NSLocalizedString(@"可用余额不足", nil)];
            return;
        }
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
    [self tradeRam];
}


- (void)tradeRam{
    if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionBuyRam) {
        [self buyRam];
    }else if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionSellRam){
        [self sellRam];
    }
}

- (void)buyRam{
    self.buy_ram_abi_json_to_bin_request.action = ContractAction_BUYRAM;
    self.buy_ram_abi_json_to_bin_request.code = ContractName_EOSIO;
    self.buy_ram_abi_json_to_bin_request.payer = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.receiver = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.quant = [NSString stringWithFormat:@"%.4f %@",self.headerView.eosAmountTF.text.doubleValue, SymbolName_EOS];
    WS(weakSelf);
    [self.buy_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText: NSLocalizedString(@"本地无此账号!", nil) ];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_BUYRAM;
        weakSelf.transferService.sender = weakSelf.eosResourceResult.data.account_name;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)sellRam{
    self.sell_ram_abi_json_to_bin_request.action = ContractAction_SELLRAM;
    self.sell_ram_abi_json_to_bin_request.code = ContractName_EOSIO;
    self.sell_ram_abi_json_to_bin_request.account = self.eosResourceResult.data.account_name;
    double bytes;
    bytes = self.headerView.eosAmountTF.text.doubleValue * 1024;
    self.sell_ram_abi_json_to_bin_request.bytes = [NSNumber numberWithDouble:bytes];
    WS(weakSelf);
    [self.sell_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText: NSLocalizedString(@"本地无此账号!", nil) ];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_SELLRAM;
        weakSelf.transferService.sender = weakSelf.eosResourceResult.data.account_name;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


// TransferServiceDelegate
extern NSString *TradeRamDidSuccessNotification;
- (void)pushTransactionDidFinish:(EOSResourceResult *)result{
    if ([result.code isEqualToNumber:@0]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"交易成功!", nil)];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self removeLoginPasswordView];
    [self loadNewData];
    self.headerView.eosAmountTF.text = nil;
}

- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

@end
