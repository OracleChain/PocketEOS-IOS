//
//  BBLoginViewController.m
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BBLoginViewController.h"
#import "BBLoginHeaderView.h"
#import "LoginMainViewController.h"
#import "BBLoginCreateWalletView.h"
#import "BBLoginChooseWalletFooterView.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "CreatePocketViewController.h"
#import "CreateAccountViewController.h"
#import "RtfBrowserViewController.h"
#import "Choose_BB_walletBtn.h"

@interface BBLoginViewController ()<BBLoginHeaderViewDelegate, BBLoginCreateWalletViewDelegate, BBLoginChooseWalletFooterViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic , strong) BBLoginHeaderView *loginHeaderView;
@property(nonatomic , strong) BBLoginCreateWalletView *createWalletView;
@property(nonatomic , strong) BBLoginChooseWalletFooterView *chooseWalletFooterView;
@property(nonatomic , strong) UIView *chooseWalletBackgroundView;
@property(nonatomic , strong) NSString *choosed_wallet_id;
@property(nonatomic , strong) NSMutableArray *select_BB_walelt_Btn_Array;
@end

@implementation BBLoginViewController

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
        if (localWalletsArr.count > 0) {
             _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.chooseWalletBackgroundView.height_sd);
        }else{
            _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.createWalletView.height_sd);
        }
        
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrollView;
}


- (BBLoginHeaderView *)loginHeaderView{
    if (!_loginHeaderView) {
        _loginHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginHeaderView" owner:nil options:nil] firstObject];
        _loginHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        _loginHeaderView.delegate = self;
    }
    return _loginHeaderView;
}

- (BBLoginCreateWalletView *)createWalletView{
    if (!_createWalletView) {
        _createWalletView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginCreateWalletView" owner:nil options:nil] firstObject];
        _createWalletView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 400);
        _createWalletView.delegate = self;
    }
    return _createWalletView;
}
- (BBLoginChooseWalletFooterView *)chooseWalletFooterView{
    if (!_chooseWalletFooterView) {
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        CGFloat cellHeight = 50.5;
        _chooseWalletFooterView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginChooseWalletFooterView" owner:nil options:nil] firstObject];
        _chooseWalletFooterView.frame = CGRectMake(0, 35+ allLocalWallet.count * cellHeight, SCREEN_WIDTH, SCREEN_HEIGHT-200-35-allLocalWallet.count * cellHeight);
        _chooseWalletFooterView.delegate = self;
    }
    return _chooseWalletFooterView;
}

- (UIView *)chooseWalletBackgroundView{
    if (!_chooseWalletBackgroundView) {
        _chooseWalletBackgroundView = [[UIView alloc] init];
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        CGFloat cellHeight = 50.5;
        
        _chooseWalletBackgroundView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"请选择钱包:";
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(MARGIN_20, MARGIN_15, 150, MARGIN_15);
        [_chooseWalletBackgroundView addSubview:label];
        for (int i = 0 ; i < allLocalWallet.count; i++) {
            Wallet *wallet = allLocalWallet[i];
            UIView *backgroundCellView = [[UIView alloc] init];
            backgroundCellView.frame = CGRectMake(MARGIN_20, 35 + i*cellHeight, SCREEN_WIDTH, cellHeight);
            [_chooseWalletBackgroundView addSubview:backgroundCellView];
            
            Choose_BB_walletBtn *btn = [[Choose_BB_walletBtn alloc] init];
            btn.frame = CGRectMake(0, 16, SCREEN_WIDTH - (MARGIN_20 *2), 17);
            [btn setImage:[UIImage imageNamed:@"unSelect__BB_wallet_icon"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"select__BB_wallet_icon"] forState:(UIControlStateSelected)];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btn setTitleColor:HEX_RGB(0x1C1D2E) forState:(UIControlStateNormal)];
            [btn setTitle:wallet.wallet_name forState:(UIControlStateNormal)];
            btn.tag = wallet.ID.integerValue;
            [btn addTarget:self action:@selector(chooseWalletBtnDicClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [backgroundCellView addSubview:btn];
            [self.select_BB_walelt_Btn_Array addObject:btn];

            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(MARGIN_20, 49, SCREEN_WIDTH-MARGIN_20, DEFAULT_LINE_HEIGHT);
            lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
            [backgroundCellView addSubview:lineView];
        }
        
        
        [_chooseWalletBackgroundView addSubview:self.chooseWalletFooterView];
        
    }
    return _chooseWalletBackgroundView;
}

- (NSMutableArray *)select_BB_walelt_Btn_Array{
    if (!_select_BB_walelt_Btn_Array) {
        _select_BB_walelt_Btn_Array = [[NSMutableArray alloc] init];
    }
    return _select_BB_walelt_Btn_Array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [LEETheme startTheme:BLACKBOX_MODE];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.loginHeaderView];
    
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    if (localWalletsArr.count > 0) {
        [self.mainScrollView addSubview:self.chooseWalletBackgroundView];
    }else{
        [self.mainScrollView addSubview:self.createWalletView];
    }
    
}


// BBLoginHeaderViewDelegate
-(void)changeModeToSocialMode{
    LoginMainViewController *vc = [[LoginMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseWalletBtnDicClick:(UIButton *)sender{
    // 单选
    for (UIButton *btn in self.select_BB_walelt_Btn_Array ) {
        if (sender == btn) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    NSLog(@"%ld",(long)sender.tag);
    self.choosed_wallet_id = [NSString stringWithFormat:@"%ld", (long)sender.tag];
}

// BBLoginCreateWalletViewDelegate
-(void)nextStepBtnDidClick{
    if (self.createWalletView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    
    
    if (IsStrEmpty(self.createWalletView.walletNameTF.text)) {
        [TOASTVIEW showWithText:@"钱包名称不能为空!"];
        return;
    }
    if (IsStrEmpty(self.createWalletView.passwordTF.text)) {
        [TOASTVIEW showWithText:@"密码不能为空!"];
        return;
    }
    if (![self.createWalletView.confirmPasswordTF.text isEqualToString:self.createWalletView.passwordTF.text]) {
        [TOASTVIEW showWithText:@"两次输入的密码不一致!"];
        return;
    }
    // 查重本地钱包名不可重复
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *model in localWalletsArr) {
        if ([model.wallet_name isEqualToString:self.createWalletView.walletNameTF.text]) {
            [TOASTVIEW showWithText:@"本地钱包名不可重复!"];
            return;
        }
    }
    // 如果本地没有钱包
    Wallet *model = [[Wallet alloc] init];
    model.wallet_name = self.createWalletView.walletNameTF.text;
    
    
    NSString *randomStr = [NSString randomStringWithLength:32];
    NSString *encryptStr = [NSString stringWithFormat:@"%@%@", randomStr,self.createWalletView.passwordTF.text];
    NSString *password_sha256 = [encryptStr sha256];
    NSString *savePassword = [NSString stringWithFormat:@"%@%@", randomStr,password_sha256];
    
    
    
    
    model.wallet_shapwd = savePassword;
    model.wallet_uid = [model.wallet_name sha256];
    model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,model.wallet_uid];
    [[WalletTableManager walletTable] addRecord: model];
    [[NSUserDefaults standardUserDefaults] setObject: model.wallet_uid  forKey:Current_wallet_uid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 创建账号(本地数据库)
    CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
    vc.createAccountViewControllerFromVC = CreateAccountViewControllerFromCreatePocketVC;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)explainBlackBoxModeBtnDidClick{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"SpecificationBlackBoxMode";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
}


//BBLoginChooseWalletFooterViewDelegate
- (void)confirmBtnDidClick{
    if (self.chooseWalletFooterView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    NSArray *localWalletArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *wallet in localWalletArr) {
        if ([wallet.ID isEqualToString:self.choosed_wallet_id]) {
            [[NSUserDefaults standardUserDefaults] setObject: wallet.wallet_uid  forKey:Current_wallet_uid];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"%@", wallet.account_info_table_name);
            // 如果本地有当前账号对应的钱包
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
            break;
        }
    }
}

- (void)createBtnDidClick{
    
    // 创建钱包(本地数据库)
    CreatePocketViewController *vc = [[CreatePocketViewController alloc] init];
    vc.createPocketViewControllerFromMode = CreatePocketViewControllerFromBlackBoxMode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)explainBtnDidClick{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"SpecificationBlackBoxMode";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
