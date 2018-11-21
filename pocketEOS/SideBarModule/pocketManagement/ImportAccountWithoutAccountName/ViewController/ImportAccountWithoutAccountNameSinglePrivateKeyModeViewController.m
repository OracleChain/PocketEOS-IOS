//
//  ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController.h"
#import "ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView.h"
#import "Get_account_permission_service.h"
#import "EOS_Key_Encode.h"
#import "BackupEOSAccountService.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "BackupAccountViewController.h"
#import "ImportAccountWithoutAccountNameService.h"
#import "ImportAccountModel.h"
#import "ImportAccount_AccounsNameDataSourceView.h"



@interface ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController ()<ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderViewDelegate , LoginPasswordViewDelegate, ImportAccount_AccounsNameDataSourceViewDelegate>

@property(nonatomic , strong) ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) Get_account_permission_service *get_account_permission_service;
@property(nonatomic , strong) BackupEOSAccountService *backupEOSAccountService;
@property(nonatomic , strong) ImportAccountWithoutAccountNameService *mainService;
@property(nonatomic , strong) ImportAccount_AccounsNameDataSourceView *importAccount_AccounsNameDataSourceView;
@property(nonatomic , strong) ImportAccountModel *importAccountModel;
@property(nonatomic , strong) NSMutableArray  *finalImportAccountModelArray;
@end

@implementation ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController

{
    // 在本地根据私钥算出的公钥
    NSString *public_key_1_from_local;
    BOOL private_Key_1_is_validate;
}


- (ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

- (BackupEOSAccountService *)backupEOSAccountService{
    if (!_backupEOSAccountService) {
        _backupEOSAccountService = [[BackupEOSAccountService alloc] init];
    }
    return _backupEOSAccountService;
}

- (ImportAccountWithoutAccountNameService *)mainService{
    if (!_mainService) {
        _mainService = [[ImportAccountWithoutAccountNameService alloc] init];
    }
    return _mainService;
}

- (Get_account_permission_service *)get_account_permission_service{
    if (!_get_account_permission_service) {
        _get_account_permission_service = [[Get_account_permission_service alloc] init];
    }
    return _get_account_permission_service;
}

- (ImportAccount_AccounsNameDataSourceView *)importAccount_AccounsNameDataSourceView{
    if (!_importAccount_AccounsNameDataSourceView) {
        _importAccount_AccounsNameDataSourceView = [[ImportAccount_AccounsNameDataSourceView alloc] init];
        _importAccount_AccounsNameDataSourceView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        _importAccount_AccounsNameDataSourceView.delegate = self;
    }
    return _importAccount_AccounsNameDataSourceView;
}

-(NSMutableArray *)finalImportAccountModelArray{
    if (!_finalImportAccountModelArray) {
        _finalImportAccountModelArray = [NSMutableArray array];
    }
    return _finalImportAccountModelArray;
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
    
    [self.view addSubview:self.headerView];
}



//ImportAccountWithoutAccountNameSinglePrivateKeyModeHeaderViewDelegate
- (void)importAccountWithoutAccountNameSinglePrivateKeyModeHeaderViewConfirmBtnDidClick{
    if (IsStrEmpty(self.headerView.textView.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请保证输入信息的完整~", nil)];
        return;
    }else{
        [WINDOW addSubview:self.loginPasswordView];
    }
    
}

// LoginPasswordViewDelegate
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
    [SVProgressHUD show];
    
    // 验证 account_name. owner_private_key , active_private_key 是否匹配
    [self validateInputFormat];
}

// 检查输入的格式
- (void)validateInputFormat{
    // 验证私钥格式是否正确
    private_Key_1_is_validate = [EOS_Key_Encode validateWif:self.headerView.textView.text];
    
    if (private_Key_1_is_validate == YES) {
        [self createPublicKeys];
        [self.loginPasswordView removeFromSuperview];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
        [self removeLoginPasswordView];
        
    }
}

- (void)createPublicKeys{
    // 将用户导入的私钥生成公钥
    public_key_1_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.textView.text];
    [self requestAccountsAccordingPublicKey];
}

- (void)requestAccountsAccordingPublicKey{
    WS(weakSelf);
    self.mainService.public_key = VALIDATE_STRING(public_key_1_from_local);
    [self.mainService get_key_accounts:^(NSArray *importAccountModelArray, BOOL isSuccess) {
        weakSelf.finalImportAccountModelArray = [NSMutableArray arrayWithArray:importAccountModelArray];
        [WINDOW addSubview:weakSelf.importAccount_AccounsNameDataSourceView];
        [weakSelf.importAccount_AccounsNameDataSourceView updateViewWithArray:weakSelf.finalImportAccountModelArray];
    }];
}


//ImportAccount_AccounsNameDataSourceViewDelegate

- (void)importAccount_AccounsNameDataSourceViewConfirmBtnDidClick{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
}

- (void)importAccount_AccounsNameDataSourceViewCloseBtnDidClick{}

- (void)importAccount_AccounsNameDataSourceViewTableViewCellDidClick:(ImportAccountModel *)model{
    // should import account
    // 请求该账号的公钥
    WS(weakSelf);
    self.importAccountModel = model;
    self.get_account_permission_service.getAccountRequest.name = VALIDATE_STRING(model.accountName) ;
    [self.get_account_permission_service getAccountPermission:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf configAccountInfo];
        }
    }];
    
}



// config account after import
- (void)configAccountInfo{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    accountInfo.account_name = self.importAccountModel.accountName;
    accountInfo.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
    accountInfo.is_privacy_policy = @"0";
    
    NSString *privateKey_textView1 = [AESCrypt encrypt:self.headerView.textView.text password:self.loginPasswordView.inputPasswordTF.text];
    
    if ([self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && ![self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]) {//只owner匹配
        accountInfo.account_owner_public_key = public_key_1_from_local;
        accountInfo.account_owner_private_key = privateKey_textView1;
        accountInfo.account_active_public_key = @"";
        accountInfo.account_active_private_key = @"";
        [self saveAccountWithAccountInfo:accountInfo];
    }else if (![self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && [self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]){// //只active匹配
        accountInfo.account_owner_public_key = @"";
        accountInfo.account_owner_private_key = @"";
        accountInfo.account_active_public_key = public_key_1_from_local;
        accountInfo.account_active_private_key = privateKey_textView1;
        [self saveAccountWithAccountInfo:accountInfo];
    }else if ([self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && [self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]){//owner和active全部匹配
        accountInfo.account_owner_public_key = public_key_1_from_local;
        accountInfo.account_owner_private_key = privateKey_textView1;
        accountInfo.account_active_public_key = public_key_1_from_local;
        accountInfo.account_active_private_key = privateKey_textView1;
        [self saveAccountWithAccountInfo:accountInfo];
    }else{//不匹配 导入失败
        [TOASTVIEW showWithText:NSLocalizedString(@"权限错误", nil)];
        for (ImportAccountModel *model in self.finalImportAccountModelArray) {
            if ([model.accountName isEqualToString:self.importAccountModel.accountName]) {
                model.status = 4;
            }
        }
    }
    

    [self.importAccount_AccounsNameDataSourceView updateViewWithArray:self.finalImportAccountModelArray];
}


- (void)saveAccountWithAccountInfo:(AccountInfo *)accountInfo{
    NSMutableArray *tmpArr =[[AccountsTableManager accountTable] selectAccountTable];
    if (tmpArr.count == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:VALIDATE_STRING(accountInfo.account_name)  forKey:Current_Account_name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[AccountsTableManager accountTable] addRecord:accountInfo];
    [WalletUtil setMainAccountWithAccountInfoModel:accountInfo];
    
    self.backupEOSAccountService.backupEosAccountRequest.uid = CURRENT_WALLET_UID;
    self.backupEOSAccountService.backupEosAccountRequest.eosAccountName = accountInfo.account_name;
    [self.backupEOSAccountService backupAccount:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"备份到服务器成功!");
        }
    }];
    [TOASTVIEW showWithText:NSLocalizedString(@"导入账号成功!", nil)];
    
    for (ImportAccountModel *model in self.finalImportAccountModelArray) {
        if ([model.accountName isEqualToString:self.importAccountModel.accountName]) {
            model.status = 1;
        }
    }
    
    [self.importAccount_AccounsNameDataSourceView updateViewWithArray:self.finalImportAccountModelArray];
    
}



- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}


@end
