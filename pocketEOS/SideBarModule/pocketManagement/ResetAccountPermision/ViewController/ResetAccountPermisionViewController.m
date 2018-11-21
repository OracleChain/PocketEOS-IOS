//
//  ResetAccountPermisionViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ResetAccountPermisionViewController.h"
#import "ResetAccountPermisionHeaderView.h"
#import "EOS_Key_Encode.h"
#import "EosPrivateKey.h"
#import "CommonDialogHasTitleView.h"
#import "Abi_json_to_binRequest.h"
#import "TransferService.h"
#import "GeneratePrivateKeyView.h"

@interface ResetAccountPermisionViewController ()<ResetAccountPermisionHeaderViewDelegate , LoginPasswordViewDelegate, CommonDialogHasTitleViewDelegate, TransferServiceDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ResetAccountPermisionHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) CommonDialogHasTitleView *commonDialogHasTitleView;
@property(nonatomic , strong) GeneratePrivateKeyView *generatePrivateKeyView;
@property(nonatomic , strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property(nonatomic, strong) TransferService *mainService;
@property(nonatomic , strong) EosPrivateKey *privateKey;
@end

@implementation ResetAccountPermisionViewController


{
    // 在本地根据私钥算出的公钥
    NSString *public_key_from_local;
    BOOL private_Key_is_validate;
}


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"变更权限", nil)rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (ResetAccountPermisionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ResetAccountPermisionHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT);
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



- (CommonDialogHasTitleView *)commonDialogHasTitleView{
    if (!_commonDialogHasTitleView) {
        _commonDialogHasTitleView = [[CommonDialogHasTitleView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _commonDialogHasTitleView.delegate = self;
    }
    return _commonDialogHasTitleView;
}

- (Abi_json_to_binRequest *)abi_json_to_binRequest{
    if (!_abi_json_to_binRequest) {
        _abi_json_to_binRequest = [[Abi_json_to_binRequest alloc] init];
    }
    return _abi_json_to_binRequest;
}


- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}

- (GeneratePrivateKeyView *)generatePrivateKeyView{
    if (!_generatePrivateKeyView) {
        _generatePrivateKeyView = [[GeneratePrivateKeyView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
    }
    return _generatePrivateKeyView;
}

- (EosPrivateKey *)privateKey{
    if (!_privateKey) {
        _privateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    }
    return _privateKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self configSubViews];
}

- (void)configSubViews{
    if (self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetOwnerPrivateKey) {
        self.headerView.textView.placeholder = NSLocalizedString(@"请输入新的Owner key", nil);
        self.navView.titleLabel.text = NSLocalizedString(@"变更Owner权限", nil);
        
    }else if (self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetActivePrivateKey){
        self.headerView.textView.placeholder = NSLocalizedString(@"请输入新的Active key", nil);
        self.navView.titleLabel.text = NSLocalizedString(@"变更Active权限", nil);
    }
}

//ResetAccountPermisionHeaderViewDelegate
- (void)resetAccountPermisionHeaderViewGeneratePrivateKeyBtnDidClick{
    [self addGeneratePrivateKeyView];
}

- (void)resetAccountPermisionHeaderViewConfirmBtnDidClick{
    if (IsStrEmpty(self.headerView.textView.text) ) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请保证输入信息的完整~", nil)];
        return;
    }
    [self validateInputFormat];
}

// 检查输入的格式
- (void)validateInputFormat{
    // 验证私钥格式是否正确
    private_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.textView.text ];
    // 将用户导入的私钥生成公钥
    public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.textView.text];
    if (private_Key_is_validate == YES) {
        [self addCommonDialogHasTitleView];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
        [self removeLoginPasswordView];
        return ;
    }
}

//CommonDialogHasTitleViewDelegate
- (void)commonDialogHasTitleViewConfirmBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.loginPasswordView];
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
    
    NSMutableDictionary *argsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *authDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *keyDict = [NSMutableDictionary dictionary];
    
    [keyDict setObject:VALIDATE_STRING(public_key_from_local) forKey:@"key"];
    [keyDict setObject:@1 forKey:@"weight"];
    
    [authDict setObject:[NSArray arrayWithObject:keyDict] forKey:@"keys"];
    [authDict setObject:[NSArray array] forKey:@"accounts"];
    [authDict setObject:@1 forKey:@"threshold"];
    [authDict setObject:[NSArray array] forKey:@"waits"];
    
    [argsDict setObject:authDict forKey:@"auth"];
    [argsDict setObject:VALIDATE_STRING(self.model.account_name) forKey:@"account"];
    
    if (self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetOwnerPrivateKey) {
        [argsDict setObject:VALIDATE_STRING(@"") forKey:@"parent"];
        [argsDict setObject:VALIDATE_STRING(@"owner") forKey:@"permission"];
        
    }else if (self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetActivePrivateKey){
        [argsDict setObject:VALIDATE_STRING(@"owner") forKey:@"parent"];
        [argsDict setObject:VALIDATE_STRING(@"active") forKey:@"permission"];
        
    }
    
    
    
    NSLog(@"%@", [argsDict mj_JSONString]);
    
    [self pushActicon:argsDict];
}



- (void)pushActicon:(NSDictionary *)argsDict{
    self.abi_json_to_binRequest.code = ContractName_EOSIO;
    self.mainService.code = ContractName_EOSIO;
    self.abi_json_to_binRequest.action = ContractAction_UPDATEAUTH;
    self.mainService.action = ContractAction_UPDATEAUTH;
    self.abi_json_to_binRequest.args = argsDict;
    
    WS(weakSelf);
    [self.abi_json_to_binRequest postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        //        if (![data[@"code"] isEqualToNumber:@0]) {
        //            [weakSelf feedbackToJsWithSerialNumber:weakSelf.dappTransferModel.serialNumber andMessage:data[@"data"]];
        //            return ;
        //        }
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.model.account_name];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.mainService.sender = weakSelf.model.account_name;
        weakSelf.mainService.permission = @"owner";
        weakSelf.mainService.binargs = data[@"data"][@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.mainService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [self configAccountInfo];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}


// config account after import
- (void)configAccountInfo{
    NSString *account_private_key_save = [AESCrypt encrypt:self.headerView.textView.text password:self.loginPasswordView.inputPasswordTF.text];
    Wallet *wallet = CURRENT_WALLET;
    // update table
    BOOL result = false ;
    if (self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetOwnerPrivateKey) {
        result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_owner_public_key = '%@', account_owner_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, public_key_from_local, account_private_key_save , self.model.account_name]];
    }else if(self.resetAccountPermisionViewControllerCurrentAction == ResetAccountPermisionViewControllerResetActivePrivateKey){
        result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_active_public_key = '%@', account_active_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, public_key_from_local, account_private_key_save , self.model.account_name]];
    }
    
    if (result) {
        [TOASTVIEW showWithText:NSLocalizedString(@"变更私钥权限成功", nil)];
    }else{
        NSLog(@"导入私钥失败");
    }
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)addCommonDialogHasTitleView{
    [self.view addSubview:self.commonDialogHasTitleView];
    self.commonDialogHasTitleView.comfirmBtnText = NSLocalizedString(@"变更", nil);
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"新的公钥", nil);
    model.detail = VALIDATE_STRING(public_key_from_local);
    
    [self.commonDialogHasTitleView setModel:model];
}


- (void)addGeneratePrivateKeyView{
    
    [self.view addSubview:self.generatePrivateKeyView];
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"生成的私钥", nil);
    model.detail = NSLocalizedString(@"1.请复制私钥并妥善保存。 \n2.复制私钥后，请返回上一页并手动填入私钥，方可完成重置。 \n3.如果您不理解本页的内容，请立即停止操作，否则您将自行承担损失。", nil);
    self.generatePrivateKeyView.contentTextView.text = self.privateKey.eosPrivateKey;
    [self.generatePrivateKeyView setModel:model];
}


// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

@end
