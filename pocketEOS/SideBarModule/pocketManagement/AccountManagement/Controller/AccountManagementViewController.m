//
//  AccountManagementViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "AccountManagementHeaderView.h"
#import "NavigationView.h"
#import "ExportPrivateKeyView.h"
#import "AccountPravicyProtectionRequest.h"
#import "SetMainAccountRequest.h"
#import "SliderVerifyView.h"
#import "AskQuestionTipView.h"
#import "AppDelegate.h"
#import "LoginEntranceViewController.h"
#import "AccountManagementService.h"
#import "EOSResourceManageViewController.h"
#import "UnStakeEOSViewController.h"
#import "GetAccountRequest.h"
#import "GetAccountResult.h"
#import "GetAccount.h"
#import "Permission.h"
#import "ImportOwnerPermisionViewController.h"

@interface AccountManagementViewController ()<UIGestureRecognizerDelegate,  NavigationViewDelegate, ExportPrivateKeyViewDelegate, SliderVerifyViewDelegate, LoginPasswordViewDelegate, AskQuestionTipViewDelegate, AccountManagementHeaderViewDelegate>
@property(nonatomic , strong) AccountManagementService *mainService;
@property(nonatomic, strong) AccountManagementHeaderView *headerView;
@property(nonatomic , strong) UIView *footerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ExportPrivateKeyView *exportPrivateKeyView;
@property(nonatomic, strong) SetMainAccountRequest *setMainAccountRequest;
@property(nonatomic, strong) SliderVerifyView *sliderVerifyView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) UILabel *tipLabel;
// export privateKey and delete account action need mark off
@property(nonatomic, copy) NSString *currentAction;
@property(nonatomic, strong) AskQuestionTipView *askQuestionTipView;
@property(nonatomic, strong) AccountPravicyProtectionRequest *accountPravicyProtectionRequest;
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;

@end

@implementation AccountManagementViewController

- (AccountManagementService *)mainService{
    if (!_mainService) {
        _mainService = [[AccountManagementService alloc] init];
    }
    return _mainService;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"" rightBtnImgName:nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
            _navView.rightBtn.hidden = YES;
        }
    }
    return _navView;
}

- (AccountManagementHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AccountManagementHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 245);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        [_footerView addSubview:self.sliderVerifyView];
        [_footerView addSubview:self.tipLabel];
        self.tipLabel.frame = CGRectMake(MARGIN_20, 26+48+10, SCREEN_WIDTH-(MARGIN_20*2), 18);
    }
    return _footerView;
}

- (ExportPrivateKeyView *)exportPrivateKeyView{
    if (!_exportPrivateKeyView) {
        _exportPrivateKeyView = [[[NSBundle mainBundle] loadNibNamed:@"ExportPrivateKeyView" owner:nil options:nil] firstObject];
        _exportPrivateKeyView.frame = [UIScreen mainScreen].bounds;
        _exportPrivateKeyView.delegate = self;
    }
    return _exportPrivateKeyView;
}
- (SetMainAccountRequest *)setMainAccountRequest{
    if (!_setMainAccountRequest) {
        _setMainAccountRequest = [[SetMainAccountRequest alloc] init];
    }
    return _setMainAccountRequest;
}
- (SliderVerifyView *)sliderVerifyView{
    if (!_sliderVerifyView) {
        _sliderVerifyView = [[SliderVerifyView alloc] init];
        self.sliderVerifyView.frame = CGRectMake(MARGIN_20, 26, SCREEN_WIDTH-(MARGIN_20*2), 48);
        _sliderVerifyView.tipLabel.text = NSLocalizedString(@"滑动删除账号", nil);
        _sliderVerifyView.delegate = self;
        
        
    }
    return _sliderVerifyView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.text = NSLocalizedString(@"将滑块滑动到右侧指定位置内即可删除", nil);
        _tipLabel.textColor = HEXCOLOR(0x999999);
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

- (AskQuestionTipView *)askQuestionTipView{
    if (!_askQuestionTipView) {
        _askQuestionTipView = [[[NSBundle mainBundle] loadNibNamed:@"AskQuestionTipView" owner:nil options:nil] firstObject];
        _askQuestionTipView.frame = self.view.bounds;
        _askQuestionTipView.delegate = self;
    }
    return _askQuestionTipView;
}

- (AccountPravicyProtectionRequest *)accountPravicyProtectionRequest{
    if (!_accountPravicyProtectionRequest) {
        _accountPravicyProtectionRequest = [[AccountPravicyProtectionRequest alloc] init];
    }
    return _accountPravicyProtectionRequest;
}

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configHeaderView];
    [MobClick beginLogPageView:@"钱包管理-账号详情"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"钱包管理-账号详情"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    [self.mainTableView setTableHeaderView:self.headerView];
    [self.mainTableView setTableFooterView:self.footerView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        [self.mainTableView reloadData];
    }];
    
    self.navView.titleLabel.text = self.model.account_name;
    
    [self requestRemoteAccountInfo];
}

- (void)requestRemoteAccountInfo{
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(self.model.account_name);
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            AccountInfo *remoteAccount = [[AccountInfo alloc] init];
            remoteAccount.account_name = weakSelf.model.account_name;
            for (Permission *permission in model.permissions) {
                if ([permission.perm_name isEqualToString:@"active"]) {
                    remoteAccount.account_active_public_key = permission.required_auth_key;
                }else if ([permission.perm_name isEqualToString:@"owner"]){
                    remoteAccount.account_owner_public_key = permission.required_auth_key;
                }
            }
            [weakSelf.headerView updateViewWithRemoteAccountInfo:remoteAccount];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)configHeaderView{
    AccountInfo *localAccount = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.model.account_name];
    self.model = localAccount;
    self.headerView.localAccount = localAccount;
}

//UITableViewDelegate , UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell1 alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    
    NSString *str = self.mainService.dataSourceArray[indexPath.row];
    if ([str isEqualToString:NSLocalizedString(@"设为主账号", nil)]) {
        UISwitch *switchView = [[UISwitch alloc] init];
        if ([self.model.is_main_account isEqualToString:@"1"]) {
            switchView.on = YES;
            switchView.enabled = NO;
        }else{
            switchView.on = NO;
        }
        switchView.onTintColor = HEXCOLOR(0x4D7BFE);
        
        [switchView addTarget:self action:@selector(setToMainAccountBtnDidClick:) forControlEvents:(UIControlEventValueChanged)];
        [cell.contentView addSubview:switchView];
        switchView.sd_layout.rightSpaceToView(cell.contentView, MARGIN_20).centerYEqualToView(cell.contentView).widthIs(58).heightIs(30);
        
    }else if ([str isEqualToString:NSLocalizedString(@"保护隐私", nil)]){
        UISwitch *switchView = [[UISwitch alloc] init];
        if ([self.model.is_privacy_policy isEqualToString:@"1"]) {
            switchView.on = YES;
        }else{
            switchView.on = NO;
        }
        switchView.onTintColor = HEXCOLOR(0x4D7BFE);
        [switchView addTarget:self action:@selector(setProtectPrivate:) forControlEvents:(UIControlEventValueChanged)];
        [cell.contentView addSubview:switchView];
        switchView.sd_layout.rightSpaceToView(cell.contentView, MARGIN_20).centerYEqualToView(cell.contentView).widthIs(58).heightIs(30);
    }else{
        cell.rightIconImgName = @"right_arrow_gray";
        [cell.contentView addSubview:cell.rightIconImageView];
        cell.rightIconImageView.sd_layout.rightSpaceToView(cell.contentView, 20).widthIs(7).heightIs(14).centerYEqualToView(cell.contentView);
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = VALIDATE_STRING(self.mainService.dataSourceArray[indexPath.row]);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = self.mainService.dataSourceArray[indexPath.row];
    if ([str isEqualToString:NSLocalizedString(@"设为主账号", nil)]) {
        NSLog(@"设为主账号");
    }else if([str isEqualToString:NSLocalizedString(@"保护隐私", nil)]){
        NSLog(@"保护隐私");
    }else if([str isEqualToString:NSLocalizedString(@"EOS资源管理", nil)]){
        [MobClick event:@"钱包管理-账号详情-资源管理"];
        EOSResourceManageViewController *vc = [[EOSResourceManageViewController alloc] init];
        vc.currentAccountName = self.model.account_name;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([str isEqualToString:NSLocalizedString(@"导出私钥", nil)]){
        [self exportPrivateKeyBtnDidClick:nil];
    }else if([str isEqualToString:NSLocalizedString(@"EOS一键赎回", nil)]){
        [MobClick event:@"钱包管理-账号详情-一键赎回"];
        [self unStakeBtnClick];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

//AccountManagementHeaderViewDelegate
- (void)setToMainAccountBtnDidClick:(UISwitch *)sender{
    //  通知服务器
    self.setMainAccountRequest.uid = CURRENT_WALLET_UID;
    self.setMainAccountRequest.eosAccountName = self.model.account_name;
    [self.setMainAccountRequest postDataSuccess:^(id DAO, id data) {
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            sender.enabled = NO;
            // 1.将所有的账号都设为 非主账号
            Wallet *wallet = CURRENT_WALLET;
            [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_main_account = '0' ", wallet.account_info_table_name]];
            // 2.将当前账号设为主账号
            BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, self.model.account_name ]];
            
            [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET wallet_main_account = '%@' WHERE wallet_uid = '%@'" , WALLET_TABLE , self.model.account_name, CURRENT_WALLET_UID]];
            
            if (result) {
                [TOASTVIEW showWithText:NSLocalizedString(@"设置主账号成功!", nil)];
            }
        }else{
            [TOASTVIEW showWithText:result.message];
        }
    } failure:^(id DAO, NSError *error) {
        
    }];
}

- (void)setProtectPrivate:(UISwitch *)sender{
    WS(weakSelf);
    self.accountPravicyProtectionRequest.eosAccountName = self.model.account_name;
    if ([self.model.is_privacy_policy isEqualToString:@"0"]) {
        weakSelf.accountPravicyProtectionRequest.status = @1;
    }else if ([self.model.is_privacy_policy isEqualToString:@"1"]){
        weakSelf.accountPravicyProtectionRequest.status = @0;
    }
    [self.accountPravicyProtectionRequest postDataSuccess:^(id DAO, id data) {
        if ([data[@"code"] isEqual:@0]) {
            Wallet *wallet = CURRENT_WALLET;
            [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_privacy_policy = '%@' WHERE account_name = '%@'" , wallet.account_info_table_name , [NSString stringWithFormat:@"%@" , weakSelf.accountPravicyProtectionRequest.status]  , self.model.account_name]];
            weakSelf.model.is_privacy_policy = [NSString stringWithFormat:@"%@" , weakSelf.accountPravicyProtectionRequest.status];
        }else{
            [TOASTVIEW showWithText:data[@"message"]];
        }
    } failure:^(id DAO, NSError *error) {}];
}

- (void)unStakeBtnClick{
    UnStakeEOSViewController *vc = [[UnStakeEOSViewController alloc] init];
    //    self.currentAccountResult.data.eos_cpu_weight = @"6";
    //    self.currentAccountResult.data.eos_net_weight = @"8";
    vc.currentAccountName = self.model.account_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exportPrivateKeyBtnDidClick:(UIButton *)sender{
    self.currentAction = @"ExportPrivateKey";
    [self.view addSubview:self.loginPasswordView];
}

// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self removePasswordView];
    self.currentAction = nil;
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        [self removePasswordView];
        return;
    }
    
    if ([self.currentAction isEqualToString:@"ExportPrivateKey"]) {
        [self.view addSubview:self.exportPrivateKeyView];
        AccountInfo *model = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.model.account_name];
        NSString *privateKeyStr = [NSString stringWithFormat:@"OWNKEY:\n%@    \n\nACTIVEKEY：\n%@\n",  [AESCrypt decrypt:model.account_owner_private_key password:self.loginPasswordView.inputPasswordTF.text],[AESCrypt decrypt:model.account_active_private_key password:self.loginPasswordView.inputPasswordTF.text]];
        self.exportPrivateKeyView.contentTextView.text = privateKeyStr;
        [self.loginPasswordView removeFromSuperview];
    }else if ([self.currentAction isEqualToString:@"DeleteAccount"]){
        // 删除账号
        NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
        if (accountArr.count > 1) {
            BOOL result = [[AccountsTableManager accountTable] executeUpdate: [NSString stringWithFormat:@"DELETE FROM '%@' WHERE account_name = '%@'", current_wallet.account_info_table_name,self.model.account_name]];
            // 再默认设置一个主账号
            NSMutableArray *newAccountsArr = [[AccountsTableManager accountTable] selectAccountTable];
            AccountInfo *model = newAccountsArr[0];
            //  通知服务器
            self.setMainAccountRequest.uid = CURRENT_WALLET_UID;
            self.setMainAccountRequest.eosAccountName = model.account_name;
            [self.setMainAccountRequest postDataSuccess:^(id DAO, id data) {
                BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
                if ([result.code isEqualToNumber:@0]) {
                    // 1.将所有的账号都设为 非主账号
                    Wallet *wallet = CURRENT_WALLET;
                    [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_main_account = '0' ", wallet.account_info_table_name]];
                    
                    // update account table
                    BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, model.account_name ]];
                    
                    // update wallet table
                    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET wallet_main_account = '%@' WHERE wallet_uid = '%@'" , WALLET_TABLE , model.account_name, CURRENT_WALLET_UID]];
                    NSLog(@"设置主账号成功");
                }else{
                    [TOASTVIEW showWithText:result.message];
                }
                
            } failure:^(id DAO, NSError *error) {
                    
            }];
            
                
            if (result) {
                [TOASTVIEW showWithText:NSLocalizedString(@"删除账号成功!", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{ 
             [self.view addSubview:self.askQuestionTipView];
             self.askQuestionTipView.titleLabel.text = NSLocalizedString(@"检测到您钱包下只有一个账号,继续将执行注销钱包操作!请谨慎~", nil);
            
        }
        self.loginPasswordView.inputPasswordTF.text = nil;
    }
}

// AskQuestionTipViewDelegate
- (void)askQuestionTipViewCancleBtnDidClick:(UIButton *)sender{
    [self.askQuestionTipView removeFromSuperview];
}

- (void)askQuestionTipViewConfirmBtnDidClick:(UIButton *)sender{
    Wallet *current_wallet = CURRENT_WALLET;
    // 移除本地数据, 调到登录页面
    [[WalletTableManager walletTable] deleteRecord:CURRENT_WALLET_UID];
    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"DROP TABLE '%@'" , current_wallet.account_info_table_name]];
    
    for (UIView *view in WINDOW.subviews) {
        [view removeFromSuperview];
        
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginEntranceViewController alloc] init]];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: navi];
}


// SliderVerifyViewDelegate
- (void)sliderVerifyDidSuccess{
    self.currentAction = @"DeleteAccount";
    [self.view addSubview:self.loginPasswordView];
}

//ExportPrivateKeyViewDelegate
- (void)genetateQRBtnDidClick:(UIButton *)sender{
    AccountInfo *model = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.model.account_name];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(model.account_name)  forKey:@"account_name"];
    [params setObject: VALIDATE_STRING([AESCrypt decrypt:model.account_active_private_key password:self.loginPasswordView.inputPasswordTF.text])  forKey:@"active_private_key"];
    [params setObject: VALIDATE_STRING([AESCrypt decrypt:model.account_owner_private_key password:self.loginPasswordView.inputPasswordTF.text])  forKey:@"owner_private_key"];
    [params setObject:@"account_priviate_key_QRCode" forKey:@"type"];
    NSString *jsonStr = [params mj_JSONString];
    self.exportPrivateKeyView.QRCodeimg.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:jsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
}

- (void)copyBtnDidClick:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.exportPrivateKeyView.contentTextView.text;
}

// NavigationViewDelegate
- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removePasswordView{
    [self.loginPasswordView removeFromSuperview];
    self.loginPasswordView = nil;
}

//AccountManagementHeaderViewDelegate
- (void)ownerTipLabelDidTap{
    ImportOwnerPermisionViewController *vc = [[ImportOwnerPermisionViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
