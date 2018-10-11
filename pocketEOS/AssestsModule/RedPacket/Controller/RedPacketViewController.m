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
#import "TransactionRecordTableViewCell.h"
#import "RedPacketRecordResult.h"
#import "RedPacketRecord.h"
#import "TransferAbi_json_to_bin_request.h"
#import "RedPacketRecordsViewController.h"
#import "TokenInfo.h"

@interface RedPacketViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, RedPacketHeaderViewDelegate, TransferServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) RedPacketHeaderView *headerView;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) NSString *currentAssestsType;
@property(nonatomic, strong) GetRateResult *getRateResult;
@property(nonatomic, strong) GetRateRequest *getRateRequest;
@property(nonatomic , strong) RedPacket *redPacket;
@property(nonatomic , strong) RedpacketService *mainService;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic , copy) NSString *assest_price_cny;
@end

@implementation RedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"发红包", nil) rightBtnTitleName:NSLocalizedString(@"红包记录", nil) delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (RedPacketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RedPacketHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 400);
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

- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentAccountName = CURRENT_ACCOUNT_NAME;
    // 设置资产
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
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
    [self.view addSubview:self.headerView];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    self.currentAssestsType = @"EOS";
    [self requestRate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.amountTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.headerView.redPacketCountTF];
}

- (void)requestRate{
    NSArray *tmpArr = [ArchiveUtil unarchiveTokenInfoArray];
    for (TokenInfo *token in tmpArr) {
        {//self.get_token_info_service_data_array
            if ([token.token_symbol isEqualToString:self.currentAssestsType]) {
                self.assest_price_cny = token.asset_price_cny;
                [self textFieldChange:nil];
            }
        }
    }

}


- (void)textFieldChange:(NSNotification *)notification {
    BOOL isCanSubmit = (self.headerView.amountTF.text.length != 0 && self.headerView.redPacketCountTF.text.length != 0);
    if (isCanSubmit) {
        [self.headerView.sendRedpacketBtn setBackgroundColor: HEXCOLOR(0xD82919)];
    } else {
        [self.headerView.sendRedpacketBtn setBackgroundColor: HEXCOLOR(0xB3E05447)];
    }
    self.headerView.sendRedpacketBtn.enabled = isCanSubmit;
    
    
    self.headerView.tipLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(self.headerView.amountTF.text.doubleValue * self.assest_price_cny.doubleValue)]];
    
    
}

// NavigationView delegate
- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    [MobClick event:@"红包_红包记录"];
    RedPacketRecordsViewController *vc = [[RedPacketRecordsViewController alloc] init];
    vc.currentAssestsType = self.currentAssestsType;
    [self.navigationController pushViewController:vc animated:YES];
}


// headerViewDelegate
- (void)selectAssestsBtnDidClick:(UIButton *)sender {
    WS(weakSelf);
    [self.view endEditing:YES];
    NSArray *assestsArr = @[@"EOS" , @"OCT"];
    [CDZPicker showSinglePickerInView:self.view withBuilder:[CDZPickerBuilder new] strings:assestsArr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.currentAssestsType = VALIDATE_STRING(strings[0]);
        weakSelf.headerView.assestChooserLabel.text = weakSelf.currentAssestsType;
        weakSelf.mainService.getRedPacketRecordRequest.type = weakSelf.currentAssestsType;
        [weakSelf requestRate];
    }cancel:^{
        NSLog(@"user cancled");
    }];
    
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
    self.mainService.sendRedpacketRequest.account = CURRENT_ACCOUNT_NAME;
    self.mainService.sendRedpacketRequest.amount = @(self.headerView.amountTF.text.doubleValue);
    self.mainService.sendRedpacketRequest.packetCount = @(self.headerView.redPacketCountTF.text.integerValue);
    self.mainService.sendRedpacketRequest.type = self.currentAssestsType;
    self.mainService.sendRedpacketRequest.remark = IsStrEmpty(self.headerView.memoTV.text) ?  @"" :  self.headerView.memoTV.text ;
    
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
    self.transferAbi_json_to_bin_request.from = CURRENT_ACCOUNT_NAME;
    self.transferAbi_json_to_bin_request.to = RedPacketReciever;
    self.transferAbi_json_to_bin_request.memo = IsStrEmpty(self.headerView.memoTV.text) ?  [NSString stringWithFormat:@"%@,", self.redPacket.redpacket_id] : [NSString stringWithFormat:@"%@,%@", self.redPacket.redpacket_id, self.headerView.memoTV.text] ;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_TRANSFER;
        weakSelf.transferService.sender = CURRENT_ACCOUNT_NAME;
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
    WS(weakSelf);
    if ([result.code isEqualToNumber:@0]) {
        NSLog(NSLocalizedString(@"转账到eosredpacket成功!", nil));
        self.mainService.payOrderRequest.userId = CURRENT_WALLET_UID;
        self.mainService.payOrderRequest.outTradeNo = self.redPacket.redpacket_id;
        self.mainService.payOrderRequest.trxId = result.transaction_id;
        self.mainService.payOrderRequest.memo = IsStrEmpty(self.headerView.memoTV.text) ?  [NSString stringWithFormat:@"%@,", self.redPacket.redpacket_id] : [NSString stringWithFormat:@"%@,%@", self.redPacket.redpacket_id, self.headerView.memoTV.text];
        self.mainService.payOrderRequest.blockNum = self.transferService.ref_block_num;
        self.mainService.payOrderRequest.prepayId = self.redPacket.prepayId;
        
        [self.mainService payOrder:^(id service, BOOL isSuccess) {
            
            ForwardRedPacketViewController *vc = [[ForwardRedPacketViewController alloc] init];
            RedPacketModel *model = [[RedPacketModel alloc] init];
            model.from = CURRENT_ACCOUNT_NAME;
            model.amount = weakSelf.headerView.amountTF.text;
            model.count = weakSelf.headerView.redPacketCountTF.text;
            model.coin = weakSelf.currentAssestsType;
            model.memo = weakSelf.headerView.memoTV.text ;
            model.amount = weakSelf.headerView.amountTF.text;
            model.transactionId = result.transaction_id;
            model.redPacket_id = weakSelf.redPacket.redpacket_id;
            vc.redPacketModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
