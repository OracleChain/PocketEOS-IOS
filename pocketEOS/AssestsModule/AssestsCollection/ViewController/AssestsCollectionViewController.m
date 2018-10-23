//
//  AssestsCollectionViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionViewController.h"
#import "ExcuteActions.h"
#import "ExcuteMultipleActionsService.h"
#import "TransactionResult.h"
#import "AssestsCollectionMainService.h"
#import "AssestsCollectionHeaderView.h"
#import "AssestsCollectionFooterView.h"
#import "Get_token_info_service.h"
#import "GetTokenInfoResult.h"
#import "TokenInfo.h"
#import "AssestsCollectionTableViewCell.h"
#import "AssestsCollectionDetailViewController.h"

@interface AssestsCollectionViewController ()<LoginPasswordViewDelegate, ExcuteMultipleActionsServiceDelegate, AssestsCollectionHeaderViewDelegate, AssestsCollectionFooterViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) AssestsCollectionHeaderView *headerView;
@property(nonatomic , strong) AssestsCollectionFooterView *footerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) AssestsCollectionMainService *assestsCollectionMainService;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@property(nonatomic, strong) NSString *currentAccountName;
@property(nonatomic, strong) Get_token_info_service *get_token_info_service;
@property(nonatomic , strong) TokenInfo *currentToken;

@end

@implementation AssestsCollectionViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资产归集", nil) rightBtnTitleName:NSLocalizedString(@"归集说明", nil) delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (AssestsCollectionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsCollectionHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 271.5);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (AssestsCollectionFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsCollectionFooterView" owner:nil options:nil] firstObject];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        _footerView.delegate = self;
    }
    return _footerView;
}



- (AssestsCollectionMainService *)assestsCollectionMainService{
    if (!_assestsCollectionMainService) {
        _assestsCollectionMainService = [[AssestsCollectionMainService alloc] init];
    }
    return _assestsCollectionMainService;
}

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}
- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    [self.mainTableView setTableHeaderView:self.headerView];
    
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    for (AccountInfo *model in accountArray) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            AccountInfo *mainAccount = model;
            self.currentAccountName = mainAccount.account_name;
            self.headerView.accountNameLabel.text = self.currentAccountName;
        }
    }
    [self requestTokenInfoDataArray];
    [self configHeaderView];
    [self configFooterView];
    
}

- (void)buildDataSource{
    WS(weakSelf);
    self.assestsCollectionMainService.currentToken = self.currentToken;
    [self.assestsCollectionMainService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
            [weakSelf configFooterView];
        }
    }];
}

- (void)configHeaderView{
    self.headerView.assestsNameLabel.text =  IsNilOrNull(self.currentToken) ? SymbolName_EOS : self.currentToken.token_symbol;
    self.headerView.contractNameLabel.text = [NSString stringWithFormat:@"(%@)", IsNilOrNull(self.currentToken) ? ContractName_EOSIOTOKEN : self.currentToken.contract_name];
}

- (void)configFooterView{
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (TokenInfo *tokenInfo in self.assestsCollectionMainService.dataSourceArray) {
        if (tokenInfo.isSelected == YES) {
            [tmpArr addObject:tokenInfo];
        }
    }
    double totalBalanceCnyValue =0;
    for (TokenInfo *model in tmpArr) {
        totalBalanceCnyValue += model.balance.doubleValue;
    }
    self.footerView.totalAmountLabel.text = [NSString stringWithFormat:@"≈%.4f %@", totalBalanceCnyValue, self.currentToken.token_symbol];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssestsCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[AssestsCollectionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    
    TokenInfo *model = self.assestsCollectionMainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assestsCollectionMainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TokenInfo *model = self.assestsCollectionMainService.dataSourceArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [tableView reloadData];
    [self configFooterView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.5;
}

//ExcuteMultipleActionsServiceDelegate
- (void)excuteMultipleActionsDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0]) {
        NSLog(@"%@ 成功", result.transaction_id);
    }else{
        NSLog(@"%@ 失败", result.message);
    }
    NSLog(@"result.tag ::  %@\n result.transaction_id :: %@\n result.message:: %@\n", result.tag, result.transaction_id, result.message);
}



- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}


//AssestsCollectionHeaderViewDelegate
- (void)allSelectBtnDidClick{
    for (TokenInfo *model in self.assestsCollectionMainService.dataSourceArray) {
        model.isSelected = self.headerView.allSelectBtn.isSelected;
    }
    [self.mainTableView reloadData];
    [self configFooterView];
}

- (void)selectAssestBtnDidClick{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    NSMutableArray *assestsArr = [NSMutableArray array];
    builder.cancelText = NSLocalizedString(@"选择您的Token", nil);
    for (int i = 0 ; i < self.get_token_info_service.dataSourceArray.count; i++) {
        TokenInfo *token = self.get_token_info_service.dataSourceArray[i];
        if ([token.token_symbol isEqualToString:self.currentToken.token_symbol]) {
            builder.defaultIndex = i;
        }
        [assestsArr addObject: [NSString stringWithFormat:@"%@ %@", token.token_symbol, token.contract_name] ];
    }
    
    if (assestsArr.count == 0) {
        return;
    }
    WS(weakSelf);
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:assestsArr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        NSString *symbolName;
        NSString *contractName;
        NSString *resultStr = VALIDATE_STRING(strings[0]);
        NSArray *tmpArr = [resultStr componentsSeparatedByString:@" "];
        if (tmpArr.count == 2) {
            symbolName = tmpArr[0];
            contractName = tmpArr[1];
        }
        
        for (TokenInfo *token in self.get_token_info_service.dataSourceArray) {
            if ([token.token_symbol isEqualToString: symbolName] && [token.contract_name isEqualToString:contractName]) {
                weakSelf.currentToken = token;
            }
        }
        [weakSelf configHeaderView];
        [weakSelf buildDataSource];
        weakSelf.headerView.allSelectBtn.selected = NO;
    }cancel:^{
        NSLog(@"user cancled");
    }];
}



//AssestsCollectionFooterViewDelegate
- (void)assestsCollectionFooterViewConfirmBtnDidClick{

    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (TokenInfo *tokenInfo in self.assestsCollectionMainService.dataSourceArray) {
        if (tokenInfo.isSelected == YES) {
            [tmpArr addObject:tokenInfo];
        }
    }
    if (tmpArr.count == 0) {
        [TOASTVIEW showWithText:NSLocalizedString(@"至少选择一个账号", nil)];
        return;
    }
    [self.view addSubview:self.loginPasswordView];
}


//LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self removeLoginPasswordView];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    NSMutableArray *tmpTokenInfoArr = [NSMutableArray array];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (TokenInfo *tokenInfo in self.assestsCollectionMainService.dataSourceArray) {
        if (tokenInfo.isSelected == YES) {
            [tmpArr addObject:tokenInfo];
        }
    }
    
    for (int i = 0; i < tmpArr.count; i++) {
        TokenInfo *tokenInfo = tmpArr[i];
        CommonTransferModel *model = [[CommonTransferModel alloc] init];
        model.contract = tokenInfo.contract_name;
        model.from = tokenInfo.account_name;
        model.to = self.currentAccountName;
        model.amount = tokenInfo.balance;
        model.memo = [NSString stringWithFormat:@"%@%@%@%@", NSLocalizedString(@"从",  nil), model.from, NSLocalizedString(@"归集资产到",  nil), model.to];
        model.symbol = tokenInfo.token_symbol;
        model.precision = [NSString stringWithFormat:@"%lu", (unsigned long)[NSString getDecimalStringPercisionWithDecimalStr:tokenInfo.balance]];
        model.status = @"handling";
        model.resultStr = NSLocalizedString(@"交易中", nil);
        [tmpTokenInfoArr addObject:model];
    }
    
    AssestsCollectionDetailViewController *vc = [[AssestsCollectionDetailViewController alloc] init];
    vc.password = self.loginPasswordView.inputPasswordTF.text;
    vc.transferModelArr = tmpTokenInfoArr;
    [self.navigationController pushViewController:vc animated:YES];
    [self removeLoginPasswordView];
}


- (void)requestTokenInfoDataArray{
    WS(weakSelf);
    self.get_token_info_service.get_token_info_request.accountName = self.currentAccountName;
    [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (IsNilOrNull(weakSelf.currentToken)) {
                if (weakSelf.get_token_info_service.dataSourceArray.count > 0) {
                    weakSelf.currentToken = weakSelf.get_token_info_service.dataSourceArray[0];
                    [weakSelf configHeaderView];
                    [weakSelf buildDataSource];
                }
            }
        }
    }];
}




//NavigationViewDelegate
- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnDidClick{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"AssetsCollection";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
