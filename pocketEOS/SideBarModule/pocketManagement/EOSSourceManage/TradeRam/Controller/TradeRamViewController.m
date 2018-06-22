//
//  TradeRamViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TradeRamViewController.h"
#import "TradeRamHeaderView.h"
#import "Buy_ram_abi_json_to_bin_request.h"
#import "Sell_ram_abi_json_to_bin_request.h"
#import "TransferService.h"
#import "AccountInfo.h"

@interface TradeRamViewController ()<UINavigationControllerDelegate, TransferServiceDelegate, LoginPasswordViewDelegate, TradeRamHeaderViewDelegate>
@property(nonatomic , strong) TradeRamHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) Buy_ram_abi_json_to_bin_request *buy_ram_abi_json_to_bin_request;
@property(nonatomic , strong) Sell_ram_abi_json_to_bin_request *sell_ram_abi_json_to_bin_request;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferService *transferService;
@end

@implementation TradeRamViewController

- (NavigationView *)navView{
    if (!_navView) {
        NSString *title ;
        if ([self.pageType isEqualToString:NSLocalizedString(@"buy_ram", nil)]) {
            title = NSLocalizedString(@"买入存储", nil);
        }else if ([self.pageType isEqualToString:NSLocalizedString(@"sell_ram", nil)]){
            title = NSLocalizedString(@"卖出存储", nil);
        }
        
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:title rightBtnTitleName:nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.delegate = self;
    }
    return _navView;
}

- (TradeRamHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TradeRamHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 265);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    if ([self.pageType isEqualToString:NSLocalizedString(@"buy_ram", nil)]) {
        self.headerView.titleLabel.text = NSLocalizedString(@"调整买入数量 :", nil);
    }else if ([self.pageType isEqualToString:NSLocalizedString(@"sell_ram", nil)]){
        self.headerView.titleLabel.text = NSLocalizedString(@"调整卖出数量 :", nil);
    }
    
    self.headerView.eosResourceResult = self.eosResourceResult;
    self.headerView.accountResult = self.accountResult;
    self.view.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
}


//TradeRamHeaderViewDelegate

- (void)modifySliderDidSlide:(UISlider *)sender{
    NSLog(@"%f", sender.value);
    
}

-(void)confirmTradeRamBtnDidClick{
     [self.view addSubview:self.loginPasswordView];
}


// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    
    if (self.eosResourceResult.data.cpu_weight.doubleValue > 1 &&  self.eosResourceResult.data.net_weight.doubleValue > 1) {
        
        [self tradeRam];
    }else{
        [TOASTVIEW showWithText:@"无法赎回!"];
        [self.loginPasswordView removeFromSuperview];
        return;
    }
}


- (void)tradeRam{
    if ([self.pageType isEqualToString: NSLocalizedString(@"buy_ram", nil)]) {
        [self buyRam];
    }else if ([self.pageType isEqualToString: NSLocalizedString(@"sell_ram", nil)]){
        [self sellRam];
    }
}

- (void)buyRam{
    self.buy_ram_abi_json_to_bin_request.action = @"buyram";
    self.buy_ram_abi_json_to_bin_request.code = @"eosio";
    self.buy_ram_abi_json_to_bin_request.payer = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.receiver = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.quant = [NSString stringWithFormat:@"%.4f EOS",self.headerView.modifyRamSlider.value ];
    WS(weakSelf);
    [self.buy_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText:@"本地无此账号!"];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = @"buyram";
        weakSelf.transferService.sender = weakSelf.eosResourceResult.data.account_name;
        weakSelf.transferService.code = @"eosio";
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
    self.sell_ram_abi_json_to_bin_request.action = @"sellram";
    self.sell_ram_abi_json_to_bin_request.code = @"eosio";
    self.sell_ram_abi_json_to_bin_request.account = self.eosResourceResult.data.account_name;
    self.sell_ram_abi_json_to_bin_request.bytes = @"100";
    WS(weakSelf);
    [self.buy_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText:@"本地无此账号!"];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = @"sellram";
        weakSelf.transferService.sender = weakSelf.eosResourceResult.data.account_name;
        weakSelf.transferService.code = @"eosio";
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
- (void)pushTransactionDidFinish:(EOSResourceResult *)result{
    if ([result.code isEqualToNumber:@0]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"交易成功!", nil)];
        [self.navigationController popViewControllerAnimated: YES];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}



-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
@end
