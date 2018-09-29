//
//  SimpleWalletLoginViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SimpleWalletLoginViewController.h"
#import "SimpleWalletLoginModel.h"
#import "Sha256.h"
#import "uECC.h"
#import "NSObject+Extension.h"
#import "rmd160.h"
#import "libbase58.h"
#import "NSData+Hash.h"
#import "EOS_Key_Encode.h"
#import "SimpleWalletLoginHeaderView.h"
#import "TransactionResult.h"

@interface SimpleWalletLoginViewController ()<SimpleWalletLoginHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) SimpleWalletLoginHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) SimpleWalletLoginModel *simpleWalletLoginModel;
@property(nonatomic , copy) NSString *signatureStr;
@property(nonatomic , copy) NSString *timeStamp;
@end

@implementation SimpleWalletLoginViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"账户授权", nil)rightBtnTitleName:NSLocalizedString(@"", nil)delegate:self];
        _navView.leftBtn
        .lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal)
        .LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}


- (SimpleWalletLoginHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"SimpleWalletLoginHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 465);
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.simpleWalletLoginModel = [SimpleWalletLoginModel mj_objectWithKeyValues:self.scannedResult];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    
    [self.headerView.dappAvatarView sd_setImageWithURL:String_To_URL(self.simpleWalletLoginModel.dappIcon) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.headerView.dappNameLabel.text = self.simpleWalletLoginModel.dappName;
    self.headerView.eosAccountNameLabel.text = CURRENT_ACCOUNT_NAME;
}


//SimpleWalletLoginHeaderViewDelegate
-(void)confirmAuthorizationBtnDidClick{
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
    [self sign];
}


// 生成sign算法
- (void)sign{
//    let data = timestamp + account + uuID + ref     //ref为钱包名，标示来源
    NSInteger time = [[NSDate date] timeIntervalSince1970] * 1000;
    self.timeStamp = [NSString stringWithFormat:@"%ld", (long)time];
    NSString *account = CURRENT_ACCOUNT_NAME;
    NSString *ref = @"PocketEos";
    NSString *data = [NSString stringWithFormat:@"%@%@%@%@", self.timeStamp, account, self.simpleWalletLoginModel.uuID, ref];
    
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:[AESCrypt decrypt:accountInfo.account_active_private_key password:self.loginPasswordView.inputPasswordTF.text]] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return;
    }
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        self.signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        [self sendSignedResultToDappServer];
    }
}


- (void)sendSignedResultToDappServer{

    AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] init];
    [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [outerNetworkingManager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript", nil]];
    outerNetworkingManager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(@"SimpleWallet") forKey:@"protocol"];
    [params setObject:VALIDATE_STRING(@"1.0") forKey:@"version"];
    
    [params setObject:VALIDATE_NUMBER([NSNumber numberWithInteger: self.timeStamp.integerValue]) forKey:@"timestamp"];
    [params setObject:VALIDATE_STRING(self.signatureStr) forKey:@"sign"];
    [params setObject:VALIDATE_STRING(self.simpleWalletLoginModel.uuID) forKey:@"uuID"];
    [params setObject:VALIDATE_STRING(CURRENT_ACCOUNT_NAME) forKey:@"account"];
    [params setObject:VALIDATE_STRING(@"PocketEos") forKey:@"ref"];
    
    WS(weakSelf);
    NSLog(@"params %@", [params mj_JSONString]);
    NSLog(@"url %@", self.simpleWalletLoginModel.loginUrl);
    [outerNetworkingManager POST:VALIDATE_STRING(self.simpleWalletLoginModel.loginUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@" ,responseObject);
        TransactionResult *result = [TransactionResult mj_objectWithKeyValues:responseObject];
        if ([result.code isEqualToNumber:@0]) {
            [weakSelf removeLoginPasswordView];
            [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0x999999)];
            weakSelf.headerView.confirmBtn.enabled = NO;
            [weakSelf.headerView.confirmBtn setTitle:NSLocalizedString(@"授权成功", nil) forState:(UIControlStateNormal)];
        }else{
            [TOASTVIEW showWithText: result.error];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
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
