//
//  ModifyApproveViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ModifyApproveViewController.h"
#import "ModifyApproveHeaderView.h"
#import "UnstakeEosAbiJsonTobinRequest.h"
#import "Approve_Abi_json_to_bin_request.h"
#import "TransferService.h"
#import "PriceModel.h"
#import "PriceResult.h"

// 最少质押的 eos 数量
#define MIN_AMOUNT @"1.0000000"
//#define MIN_AMOUNT @"0.0010000"

@interface ModifyApproveViewController ()<UINavigationControllerDelegate, LoginPasswordViewDelegate, ModifyApproveHeaderViewDelegate, TransferServiceDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) ModifyApproveHeaderView *headerView;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic , strong) UnstakeEosAbiJsonTobinRequest *unstakeEosAbiJsonTobinRequest;
@property(nonatomic , strong) Approve_Abi_json_to_bin_request *approve_Abi_json_to_bin_request;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property (nonatomic , assign) double initProgress;
@property (nonatomic , copy) NSString *price_str;
@property (nonatomic , copy) NSString *weight_str;
@property (nonatomic , copy) NSString *eos_balance_str;
@property (nonatomic , copy) NSString *canStakeAmount_str;
@property (nonatomic , copy) NSString *total_str;
@property (nonatomic , copy) NSString *amountTFAmount_str;
@end

@implementation ModifyApproveViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"修改抵押额度", nil)rightBtnTitleName: nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.delegate = self;
    }
    return _navView;
}


- (ModifyApproveHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ModifyApproveHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 300);
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

- (UnstakeEosAbiJsonTobinRequest *)unstakeEosAbiJsonTobinRequest{
    if (!_unstakeEosAbiJsonTobinRequest) {
        _unstakeEosAbiJsonTobinRequest = [[UnstakeEosAbiJsonTobinRequest alloc] init];
    }
    return _unstakeEosAbiJsonTobinRequest;
}

- (Approve_Abi_json_to_bin_request *)approve_Abi_json_to_bin_request{
    if (!_approve_Abi_json_to_bin_request) {
        _approve_Abi_json_to_bin_request = [[Approve_Abi_json_to_bin_request alloc] init];
    }
    return _approve_Abi_json_to_bin_request;
}

-(TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self.headerView.modifyApproveSlider addTarget:self action:@selector(sliderEndDrag) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.view.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    [self buildDataSource];
}

- (void)buildDataSource{
    if (self.eosResourceResult.data.cpu_weight.length > 4 && self.eosResourceResult.data.net_weight.length > 4) {
       
        if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
            self.weight_str = [self.eosResourceResult.data.cpu_weight substringToIndex:self.eosResourceResult.data.cpu_weight.length-4];
            self.price_str = [[self.eosResourceResult.data.cpu_weight substringToIndex:self.eosResourceResult.data.cpu_weight.length-4] yw_stringByDividingBy:self.eosResourceResult.data.cpu_max withRoundingMode:(NSRoundPlain) scale:8];
            
        }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
            self.weight_str = [self.eosResourceResult.data.net_weight substringToIndex:self.eosResourceResult.data.net_weight.length-4];
            self.price_str = [[self.eosResourceResult.data.net_weight substringToIndex:self.eosResourceResult.data.net_weight.length-4] yw_stringByDividingBy:self.eosResourceResult.data.net_max withRoundingMode:(NSRoundPlain) scale:8];
        }
        self.eos_balance_str = self.accountResult.data.eos_balance;
        self.canStakeAmount_str = [self.weight_str yw_stringBySubtracting:MIN_AMOUNT withRoundingMode:(NSRoundPlain) scale:8];
        self.total_str = [self.eos_balance_str yw_stringByAdding:self.canStakeAmount_str withRoundingMode:(NSRoundPlain) scale:8];
        _initProgress = self.canStakeAmount_str.doubleValue / self.total_str.doubleValue;
        
        self.headerView.modifyApproveSlider.value = _initProgress;
        
        if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ ms",NSLocalizedString(@"预计配额", nil), [self.weight_str yw_stringByDividingBy:[self.price_str yw_stringByDividingBy:@"1000"] withRoundingMode:(NSRoundPlain) scale:4] ];
            
            
        }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ bytes", NSLocalizedString(@"预计配额", nil),[self.weight_str yw_stringByDividingBy:self.price_str withRoundingMode:(NSRoundPlain) scale:4] ];
        }
        self.headerView.amountLabel.text = [NSString stringWithFormat:@"%@ EOS", self.weight_str];
        self.amountTFAmount_str = self.weight_str;
        
        
        if ((self.eos_balance_str.doubleValue + self.weight_str.doubleValue) < MIN_AMOUNT.doubleValue) {
            [self configHeaderViewDisabled];
        }
    }
}

-(float)roundFloat:(float)price{
    return (floorf(price*100 + 0.5))/100;
}


// ModifyApproveHeaderViewDelegate
- (void)modifyApproveSliderDidSlide:(UISlider *)sender{
    // 保留两位小数
    CGFloat progress = (floorf(sender.value*100 + 0.5))/100;
    
    if (progress == 0) {
        self.headerView.amountLabel.text = [NSString stringWithFormat:@"%@ EOS", [MIN_AMOUNT yw_stringByAdding:@"0" withRoundingMode:(NSRoundPlain) scale:4]];
        
        self.amountTFAmount_str = MIN_AMOUNT;
        if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ ms",  NSLocalizedString(@"预计配额", nil),[MIN_AMOUNT yw_stringByDividingBy:[self.price_str yw_stringByDividingBy:@"1000"] withRoundingMode:(NSRoundPlain) scale:4]];
            
        }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ bytes",NSLocalizedString(@"预计配额", nil), [MIN_AMOUNT yw_stringByDividingBy:self.price_str withRoundingMode:(NSRoundPlain) scale:4]];
        }
    }else{
        self.headerView.amountLabel.text = [NSString stringWithFormat:@"%@ EOS", [MIN_AMOUNT yw_stringByAdding:[self.total_str yw_stringByMultiplyingBy:[NSString stringWithFormat:@"%.2f", progress] withRoundingMode:(NSRoundPlain) scale:8] withRoundingMode:(NSRoundPlain) scale:4]];
        self.amountTFAmount_str = [MIN_AMOUNT yw_stringByAdding:[self.total_str yw_stringByMultiplyingBy:[NSString stringWithFormat:@"%.2f", progress] withRoundingMode:(NSRoundPlain) scale:8] withRoundingMode:(NSRoundPlain) scale:4];
        if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ ms",NSLocalizedString(@"预计配额", nil), [self.amountTFAmount_str yw_stringByDividingBy:[self.price_str yw_stringByDividingBy:@"1000"] withRoundingMode:(NSRoundPlain) scale:4]];
            
        }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
            self.headerView.predictLabel.text = [NSString stringWithFormat:@"%@：%@ bytes", NSLocalizedString(@"预计配额", nil), [self.amountTFAmount_str yw_stringByDividingBy:self.price_str withRoundingMode:(NSRoundPlain) scale:4]];
        }
    }
}

- (void)sliderEndDrag{
    if (self.amountTFAmount_str.doubleValue > self.weight_str.doubleValue) {
        // 质押
        [TOASTVIEW showWithText: NSLocalizedString(@"您将增加抵押额度", nil) ];
    }else{
        // 赎回
        [TOASTVIEW showWithText: NSLocalizedString(@"您将减少抵押额度", nil) ];
    }
}

- (void)configHeaderViewDisabled{
    // cpu/net weight less than 1 . can't modify
    self.headerView.modifyApproveSlider.value = 1;
    self.headerView.modifyApproveSlider.enabled = NO;
    self.headerView.confirmBtn.enabled = NO;
    self.headerView.confirmBtn.backgroundColor = RGB(176, 176, 176);
    [self.headerView.confirmBtn setTitle:NSLocalizedString(@"无法修改", nil) forState:(UIControlStateNormal)];
}

- (void)confirmModifyBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.loginPasswordView];
}

// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self removePasswordView];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
   
    if (self.amountTFAmount_str.doubleValue > self.weight_str.doubleValue) {
        // 质押
        [self approve];
    }else{
        // 赎回
        [self unStake];
    }
}

- (void)approve{
    self.approve_Abi_json_to_bin_request.action = ContractAction_DELEGATEBW;
    self.approve_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.approve_Abi_json_to_bin_request.from = self.eosResourceResult.data.account_name;
    self.approve_Abi_json_to_bin_request.receiver = self.eosResourceResult.data.account_name;
    self.approve_Abi_json_to_bin_request.transfer = @"0";
    if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
        self.approve_Abi_json_to_bin_request.stake_cpu_quantity = [NSString stringWithFormat:@"%@ EOS", [self.amountTFAmount_str yw_stringBySubtracting:self.weight_str withRoundingMode:(NSRoundPlain) scale:4]];
        self.approve_Abi_json_to_bin_request.stake_net_quantity = @"0.0000 EOS";
    }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
        self.approve_Abi_json_to_bin_request.stake_cpu_quantity = @"0.0000 EOS";
        self.approve_Abi_json_to_bin_request.stake_net_quantity = [NSString stringWithFormat:@"%@ EOS", [self.amountTFAmount_str yw_stringBySubtracting:self.weight_str withRoundingMode:(NSRoundPlain) scale:4]];
    }
    WS(weakSelf);
    [self.approve_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText: NSLocalizedString(@"本地无此账号!", nil) ];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_DELEGATEBW;
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

- (void)unStake{
    self.unstakeEosAbiJsonTobinRequest.action = ContractAction_UNDELEGATEBW;
    self.unstakeEosAbiJsonTobinRequest.code = ContractName_EOSIO;
    self.unstakeEosAbiJsonTobinRequest.from = self.eosResourceResult.data.account_name;
    self.unstakeEosAbiJsonTobinRequest.receiver = self.eosResourceResult.data.account_name;
    if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
        self.unstakeEosAbiJsonTobinRequest.unstake_cpu_quantity = [NSString stringWithFormat:@"%@ EOS",  [self.weight_str yw_stringBySubtracting:self.amountTFAmount_str withRoundingMode:(NSRoundPlain) scale:4]];
        self.unstakeEosAbiJsonTobinRequest.unstake_net_quantity = @"0.0000 EOS";
    }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
        self.unstakeEosAbiJsonTobinRequest.unstake_cpu_quantity = @"0.0000 EOS";
        self.unstakeEosAbiJsonTobinRequest.unstake_net_quantity = [NSString stringWithFormat:@"%@ EOS", [self.weight_str yw_stringBySubtracting:self.amountTFAmount_str withRoundingMode:(NSRoundPlain) scale:4]];
    }
    WS(weakSelf);
    [self.unstakeEosAbiJsonTobinRequest postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText: NSLocalizedString(@"本地无此账号!", nil) ];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_UNDELEGATEBW;
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
extern NSString *TradeBandwidthDidSuccessNotification;
- (void)pushTransactionDidFinish:(EOSResourceResult *)result{
    if ([result.code isEqualToNumber:@0]) {
        if (self.amountTFAmount_str.doubleValue > self.weight_str.doubleValue) {
            [TOASTVIEW showWithText:NSLocalizedString(@"增加质押成功", nil) ];
        }else{
            [TOASTVIEW showWithText:NSLocalizedString(@"赎回质押成功", nil)];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeBandwidthDidSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated: YES];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self removePasswordView];;
}


- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)removePasswordView{
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}

@end
