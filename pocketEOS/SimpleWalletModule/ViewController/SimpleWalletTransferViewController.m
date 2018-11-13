//
//  SimpleWalletTransferViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SimpleWalletTransferViewController.h"
#import "SimpleWalletTransferModel.h"
#import "ExcuteMultipleActionsService.h"
#import "SimpleWalletTransferHeaderView.h"
#import "NotifyDappServerResult.h"


@interface SimpleWalletTransferViewController ()<LoginPasswordViewDelegate, ExcuteMultipleActionsServiceDelegate,SimpleWalletTransferHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) SimpleWalletTransferHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@property(nonatomic , strong) SimpleWalletTransferModel *simpleWalletTransferModel;

@end

@implementation SimpleWalletTransferViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"转账授权", nil)rightBtnTitleName:nil delegate:self];
        _navView.leftBtn
        .lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal)
        .LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.delegate = self;
    }
    return _navView;
}

- (SimpleWalletTransferHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[SimpleWalletTransferHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 700);
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

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerView];
    
    self.simpleWalletTransferModel = [SimpleWalletTransferModel mj_objectWithKeyValues:self.scannedResult];
    NSLog(@"simpleWalletTransferModel %@", [self.simpleWalletTransferModel mj_JSONString]);
    self.headerView.model = self.simpleWalletTransferModel;
    
    
}

//SimpleWalletTransferHeaderViewDelegate
- (void)simpleWalletTransferHeaderViewconfirmBtnDidClick{
    [self buildDataSource];
    [self.view addSubview:self.loginPasswordView];
}

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
    [self pushActions];
}

- (NSArray *)buildDataSource{
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:VALIDATE_STRING(self.simpleWalletTransferModel.from) forKey:@"actor"];
    [authorizationDict setObject:VALIDATE_STRING(@"active") forKey:@"permission"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:VALIDATE_STRING(self.simpleWalletTransferModel.from) forKey:@"from"];
    [dataDict setObject:VALIDATE_STRING(self.simpleWalletTransferModel.to) forKey:@"to"];
    [dataDict setObject:[NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", self.simpleWalletTransferModel.precision.intValue, self.simpleWalletTransferModel.amount.doubleValue], self.simpleWalletTransferModel.symbol] forKey:@"quantity"];
    [dataDict setObject:VALIDATE_STRING(self.simpleWalletTransferModel.dappData) forKey:@"memo"];
    
    [actionDict setObject:VALIDATE_STRING(self.simpleWalletTransferModel.contract) forKey:@"account"];
    [actionDict setObject:VALIDATE_STRING(@"transfer") forKey:@"name"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [actionDict setObject:dataDict forKey:@"data"];
    
    ExcuteActions *action = [ExcuteActions mj_objectWithKeyValues:actionDict];
    
    return @[action];
}


- (void)pushActions{
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.simpleWalletTransferModel.from];
    if (accountInfo) {
        [self.excuteMultipleActionsService excuteMultipleActionsWithSender:accountInfo.account_name andExcuteActionsArray:[self buildDataSource] andAvailable_keysArray:@[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)] andPassword: self.loginPasswordView.inputPasswordTF.text];//self.loginPasswordView.inputPasswordTF.text
    }else{
        [TOASTVIEW showWithText: NSLocalizedString(@"您钱包中暂无操作账号~", nil)];
    }
    [self removeLoginPasswordView];
}

//ExcuteMultipleActionsServiceDelegate
- (void)excuteMultipleActionsDidFinish:(TransactionResult *)result{
    NotifyDappServerResult *notiResult = [[NotifyDappServerResult alloc ] init];
    if ([result.code isEqualToNumber:@0 ]) {
        [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0x999999)];
        self.headerView.confirmBtn.enabled = NO;
        [self.headerView.confirmBtn setTitle:NSLocalizedString(@"转账成功", nil) forState:(UIControlStateNormal)];
        notiResult.result = @"1";
        notiResult.txID = result.transaction_id;
        
    }else{
        [TOASTVIEW showWithText: result.message];
        notiResult.result = @"2";
    }
    [self removeLoginPasswordView];
    [SVProgressHUD dismiss];
    
    
    if (!IsNilOrNull(self.simpleWalletTransferModel.callback) ) {
        notiResult.callback = self.simpleWalletTransferModel.callback;
        [self notifyDappServerExcuteActionsResultWithNotifyDappServerResult:notiResult];
    }
}



- (void)notifyDappServerExcuteActionsResultWithNotifyDappServerResult:(NotifyDappServerResult *)result{
    NSString *notifyUrl = [NSString stringWithFormat:@"%@&result=%@&txID=%@",result.callback,  result.result , result.txID];
    AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST__HTTP_BASEURL]];
    NSLog(@"notifyUrl %@", notifyUrl);
    [outerNetworkingManager GET:VALIDATE_STRING(notifyUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
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



@end
