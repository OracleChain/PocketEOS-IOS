//
//  BPVoteAmountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteAmountViewController.h"
#import "BPVoteAmountHeaderView.h"
#import "BPCandidateModel.h"
#import "RegisterAccountToVoteSystem_Abi_json_to_bin_request.h"
#import "Approve_Abi_json_to_bin_request.h"
#import "VoteProducers_Abi_json_to_bin_request.h"
#import "TransferService.h"
#import "GetNowVoteWeightRequest.h"
#import "BPVoteViewController.h"
#import "RtfBrowserViewController.h"
#import "CompleteBPVoteRequest.h"
#import "RtfBrowserWithoutThemeViewController.h"


@interface BPVoteAmountViewController ()<NavigationViewDelegate, BPVoteAmountHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, LoginPasswordViewDelegate, TransferServiceDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) BPVoteAmountHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) RegisterAccountToVoteSystem_Abi_json_to_bin_request *registerAccountToVoteSystem_Abi_json_to_bin_request;
@property(nonatomic , strong) Approve_Abi_json_to_bin_request *approve_Abi_json_to_bin_request;
@property(nonatomic , strong) VoteProducers_Abi_json_to_bin_request *voteProducers_Abi_json_to_bin_request;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic , strong) GetNowVoteWeightRequest *getNowVoteWeightRequest;
@property(nonatomic , strong) NSString *nowVoteWeight;
@property(nonatomic , strong) CompleteBPVoteRequest *completeBPVoteRequest;


@end

@implementation BPVoteAmountViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"节点投票", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    }
    return _navView;
}

- (BPVoteAmountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BPVoteAmountHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 256);
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

- (NSMutableArray *)choosedBPDataArray{
    if (!_choosedBPDataArray) {
        _choosedBPDataArray = [[NSMutableArray alloc] init];
    }
    return _choosedBPDataArray;
}

- (RegisterAccountToVoteSystem_Abi_json_to_bin_request *)registerAccountToVoteSystem_Abi_json_to_bin_request{
    if (!_registerAccountToVoteSystem_Abi_json_to_bin_request) {
        _registerAccountToVoteSystem_Abi_json_to_bin_request = [[RegisterAccountToVoteSystem_Abi_json_to_bin_request alloc] init];
    }
    return _registerAccountToVoteSystem_Abi_json_to_bin_request;
}

- (Approve_Abi_json_to_bin_request *)approve_Abi_json_to_bin_request{
    if (!_approve_Abi_json_to_bin_request) {
        _approve_Abi_json_to_bin_request = [[Approve_Abi_json_to_bin_request alloc] init];
    }
    return _approve_Abi_json_to_bin_request;
}
- (VoteProducers_Abi_json_to_bin_request *)voteProducers_Abi_json_to_bin_request{
    if (!_voteProducers_Abi_json_to_bin_request) {
        _voteProducers_Abi_json_to_bin_request = [[VoteProducers_Abi_json_to_bin_request alloc] init];
    }
    return _voteProducers_Abi_json_to_bin_request;
}

- (CompleteBPVoteRequest *)completeBPVoteRequest{
    if (!_completeBPVoteRequest) {
        _completeBPVoteRequest = [[CompleteBPVoteRequest alloc] init];
    }
    return _completeBPVoteRequest;
}

- (Account *)model{
    if (!_model) {
        _model = [[Account alloc] init];
    }
    return _model;
}
- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}
- (GetNowVoteWeightRequest *)getNowVoteWeightRequest{
    if (!_getNowVoteWeightRequest) {
        _getNowVoteWeightRequest = [[GetNowVoteWeightRequest alloc] init];
    }
    return _getNowVoteWeightRequest;
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
    self.view.backgroundColor = HEXCOLOR(0x000000);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = HEXCOLOR(0x000000);
    [self.mainTableView setTableHeaderView:self.headerView];
//    self.model.eos_balance = @"50";
//    self.model.eos_net_weight = @"10";
//    self.model.eos_cpu_weight = @"5";
    self.headerView.model = self.model;
    [self configBottomBtn];
    
    WS(weakSelf);
    [self.getNowVoteWeightRequest getDataSusscess:^(id DAO, id data) {
        weakSelf.nowVoteWeight = VALIDATE_STRING(data[@"data"]);
        [weakSelf.mainTableView reloadData];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    cell.contentView.backgroundColor = HEXCOLOR(0x000000);
    cell.textLabel.textColor = HEXCOLOR(0xFFFFFF);
    cell.detailTextLabel.textColor = HEXCOLOR(0xFFFFFF);
    cell.bottomLineView.backgroundColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
    BPCandidateModel *model = self.choosedBPDataArray[indexPath.row];
    cell.textLabel.text = model.owner;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.4f亿票", (self.model.eos_net_weight.doubleValue + self.model.eos_cpu_weight.doubleValue+ self.headerView.amountTF.text.doubleValue )* 10000 * self.nowVoteWeight.doubleValue / 1000000000000];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.choosedBPDataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43.5;
}



- (void)confirmVote{
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
    
    // 投票前需要判断自己是否注册到投票系统
    if ([self.myVoteInfoResult.code isEqualToNumber:@2]) {
        // 说明该账号还没注册到投票体统
        [self registerToVoteSystem];
        NSLog(@"说明该账号还没注册到投票体统");
    }else{
        NSLog(@"该账号已经注册到投票体统");
        if (self.headerView.amountTF.text.doubleValue > 0) {
            //        self.headerView.amountTF.text.doubleValue 追加的amount
            // 质押
            [self approveToVoteSystem];
        }else{
            if ((self.model.eos_cpu_weight.doubleValue > 0) && (self.model.eos_net_weight.doubleValue > 0)) {
                [self pushTransaction];
            }else{
                NSLog(@"当前既没有追加, 余额也为零");
                [TOASTVIEW showWithText:@"余额不足!"];
                [self.loginPasswordView removeFromSuperview];
                return;
            }
        }
    }
}

- (void)registerToVoteSystem{
    //    投票
    //    1.投票前需要将自己注册到投票系统
    [SVProgressHUD show];
    self.registerAccountToVoteSystem_Abi_json_to_bin_request.action = ContractAction_REGPROXY;
    self.registerAccountToVoteSystem_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.registerAccountToVoteSystem_Abi_json_to_bin_request.proxy = self.model.account_name;
    self.registerAccountToVoteSystem_Abi_json_to_bin_request.isproxy = @"0";
    WS(weakSelf);
    [self.registerAccountToVoteSystem_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.model.account_name];
        if (!accountInfo) {
            [TOASTVIEW showWithText:@"本地无此账号!"];
            return ;
        }
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_REGPROXY;
        weakSelf.transferService.sender = weakSelf.model.account_name;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeRegisteVoteSystem;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)approveToVoteSystem{
    //    2.押入SYS用于投票
    self.approve_Abi_json_to_bin_request.action = ContractAction_DELEGATEBW;
    self.approve_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.approve_Abi_json_to_bin_request.from = self.model.account_name;
    self.approve_Abi_json_to_bin_request.receiver = self.model.account_name;
#pragma mark -- [@"data"]
    self.approve_Abi_json_to_bin_request.stake_net_quantity = [NSString stringWithFormat:@"%.4f EOS",  self.headerView.amountTF.text.doubleValue/2];
    self.approve_Abi_json_to_bin_request.stake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS",  self.headerView.amountTF.text.doubleValue/2];
    self.approve_Abi_json_to_bin_request.transfer = @"0";
    
    WS(weakSelf);
    [self.approve_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.model.account_name];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_DELEGATEBW;
        weakSelf.transferService.sender = weakSelf.model.account_name;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeApprove;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)pushTransaction{
    //    3.投票给n个节点
    self.voteProducers_Abi_json_to_bin_request.action = ContractAction_VOTEPRODUCER;
    self.voteProducers_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.voteProducers_Abi_json_to_bin_request.voter = self.model.account_name;
    self.voteProducers_Abi_json_to_bin_request.proxy = @"";
    NSMutableArray *bpNameArr = [[NSMutableArray alloc] init];
    for (BPCandidateModel *model in self.choosedBPDataArray) {
        [bpNameArr addObject:model.owner];
    }
    // 排序
    NSArray *sortArr = [bpNameArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:(NSCaseInsensitiveSearch)];
    }];
    
    self.voteProducers_Abi_json_to_bin_request.producers = (NSMutableArray *)sortArr;
    WS(weakSelf);
    [self.voteProducers_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.model.account_name];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key), VALIDATE_STRING(accountInfo.account_active_public_key)];
        
        weakSelf.transferService.action = ContractAction_VOTEPRODUCER;
        weakSelf.transferService.sender = weakSelf.model.account_name;
        weakSelf.transferService.code = ContractName_EOSIO;
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

//TransferServiceDelegate
-(void)registeToVoteSystemQuestionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
    
        if (self.headerView.amountTF.text.doubleValue > 0) {
            [self approveToVoteSystem];
        }else{
            [TOASTVIEW showWithText:@"余额不足!"];
            [self.loginPasswordView removeFromSuperview];
            return;
        }
    }else{
        [self.loginPasswordView removeFromSuperview];
        [TOASTVIEW showWithText: result.message];
    }
}

- (void)approveDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [self pushTransaction];
    }else{
        [TOASTVIEW showWithText: result.message];
        [self.loginPasswordView removeFromSuperview];

    }
}

- (void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"投票成功!", nil)];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        [self.completeBPVoteRequest postOuterDataSuccess:^(id DAO, id data) {
            NSLog(@"%@", data);
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self.loginPasswordView removeFromSuperview];
}

//BPVoteAmountHeaderViewDelegate
-(void)sliderDidSlide:(UISlider *)sender{
    self.headerView.amountTF.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [self.mainTableView reloadData];
}

- (void)explainBtnDidClick:(UIButton *)sender{
    RtfBrowserWithoutThemeViewController *vc = [[RtfBrowserWithoutThemeViewController alloc] init];
    vc.rtfFileName = @"BP_account_will_be_locked";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configBottomBtn{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:NSLocalizedString(@"确认投票", nil)forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:HEX_RGB_Alpha(0xFFFFFF, 1) forState:(UIControlStateNormal)];
    [button setBackgroundColor:HEXCOLOR(0x0B78E3)];
    [button addTarget:self action:@selector(confirmVote) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(TABBAR_HEIGHT);
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
