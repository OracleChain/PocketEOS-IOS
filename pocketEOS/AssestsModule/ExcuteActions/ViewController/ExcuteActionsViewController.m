//
//  ExcuteActionsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ExcuteActionsViewController.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"
#import "Abi_json_to_binRequest.h"
#import "ExcuteActionsDataSourceService.h"
#import "ExcuteMultipleActionsService.h"
#import "ExcuteActionsContentTableViewCell.h"

@interface ExcuteActionsViewController ()<ExcuteMultipleActionsServiceDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property(nonatomic , strong) ExcuteActionsDataSourceService *excuteActionsDataSourceService;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , copy) NSString *choosedAccountName;
@end

@implementation ExcuteActionsViewController

- (Abi_json_to_binRequest *)abi_json_to_binRequest{
    if (!_abi_json_to_binRequest) {
        _abi_json_to_binRequest = [[Abi_json_to_binRequest alloc] init];
    }
    return _abi_json_to_binRequest;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"签名内容", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (ExcuteActionsDataSourceService *)excuteActionsDataSourceService{
    if (!_excuteActionsDataSourceService) {
        _excuteActionsDataSourceService = [[ExcuteActionsDataSourceService alloc] init];
    }
    return _excuteActionsDataSourceService;
}

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}
- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
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
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT);
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self configBottomBtn];
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.excuteActionsDataSourceService.actionsResultDict = self.actionsResultDict;
    [self.excuteActionsDataSourceService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExcuteActionsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[ExcuteActionsContentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    ExcuteActions *model = self.excuteActionsDataSourceService.dataSourceArray[indexPath.section];
    cell.model = model;
    
    if (model.authorization.count>0) {
        NSDictionary *authorizationDict = model.authorization[0];
        self.choosedAccountName = authorizationDict[@"actor"];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExcuteActions *model = self.excuteActionsDataSourceService.dataSourceArray[indexPath.section];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ExcuteActionsContentTableViewCell class]  contentViewWidth:SCREEN_WIDTH - (MARGIN_20 * 2)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.excuteActionsDataSourceService.dataSourceArray.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseHeaderView *headerLabel = [[BaseHeaderView alloc] init];
    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MARGIN_10;
}


// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
    
    if (accountInfo) {
        // 验证密码输入是否正确
        Wallet *current_wallet = CURRENT_WALLET;
        if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
            [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
            return;
        }
        
        [self.excuteMultipleActionsService excuteMultipleActionsWithSender:accountInfo.account_name andExcuteActionsArray:self.excuteActionsDataSourceService.dataSourceArray andAvailable_keysArray:@[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)] andPassword:self.loginPasswordView.inputPasswordTF.text];
        
    }else{
        [TOASTVIEW showWithText: NSLocalizedString(@"您钱包中暂无操作账号~", nil)];
    }

    [self removeLoginPasswordView];
}

// ExcuteMultipleActionsServiceDelegate
-(void)excuteMultipleActionsDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"签名成功", nil)];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self removeLoginPasswordView];
    [SVProgressHUD dismiss];
}

- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

-(void)leftBtnDidClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configBottomBtn{
    BaseConfirmButton *button = [[BaseConfirmButton alloc] init];
    [button setTitle:NSLocalizedString(@"确认签名", nil)forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(confirmSign) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(TABBAR_HEIGHT);
}

- (void)confirmSign{
    [self.view addSubview:self.loginPasswordView];
}


@end
