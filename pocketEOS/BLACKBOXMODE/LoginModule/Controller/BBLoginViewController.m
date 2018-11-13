//
//  BBLoginViewController.m
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//
#define HEADERVIEW_HEIGHT 200
#import "BBLoginViewController.h"
#import "BBLoginHeaderView.h"
#import "LoginEntranceViewController.h"
#import "BBLoginCreateWalletView.h"
#import "BBLoginChooseWalletFooterView.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "CreatePocketViewController.h"
#import "AddAccountViewController.h"
#import "RtfBrowserViewController.h"
#import "Choose_BB_walletBtn.h"

@interface BBLoginViewController ()<BBLoginHeaderViewDelegate, BBLoginCreateWalletViewDelegate, BBLoginChooseWalletFooterViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView1;
@property(nonatomic , strong) BBLoginHeaderView *loginHeaderView;
@property(nonatomic , strong) BBLoginCreateWalletView *createWalletView;
@property(nonatomic , strong) BBLoginChooseWalletFooterView *chooseWalletFooterView;
@property(nonatomic , strong) UIView *chooseWalletBackgroundView;
@property(nonatomic , strong) NSString *choosed_wallet_id;
@property(nonatomic , strong) NSMutableArray *select_BB_walelt_Btn_Array;
@end

@implementation BBLoginViewController

- (UIScrollView *)mainScrollView1{
    if (!_mainScrollView1) {
        _mainScrollView1 = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _mainScrollView1.backgroundColor = [UIColor whiteColor];
        NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
        if (localWalletsArr.count > 0) {
             _mainScrollView1.contentSize = CGSizeMake(SCREEN_WIDTH, self.chooseWalletBackgroundView.height_sd);
        }else{
            _mainScrollView1.contentSize = CGSizeMake(SCREEN_WIDTH, self.createWalletView.height_sd);
        }
        
        if (@available(iOS 11.0, *)) {
            _mainScrollView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrollView1;
}


- (BBLoginHeaderView *)loginHeaderView{
    if (!_loginHeaderView) {
        _loginHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginHeaderView" owner:nil options:nil] firstObject];
        _loginHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT);
        _loginHeaderView.delegate = self;
    }
    return _loginHeaderView;
}

- (BBLoginCreateWalletView *)createWalletView{
    if (!_createWalletView) {
        _createWalletView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginCreateWalletView" owner:nil options:nil] firstObject];
        if ([DeviceType getIsIpad]) {
            _createWalletView.frame = CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        }else{
            _createWalletView.frame = CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- HEADERVIEW_HEIGHT);
        }
        _createWalletView.delegate = self;
    }
    return _createWalletView;
}
- (BBLoginChooseWalletFooterView *)chooseWalletFooterView{
    if (!_chooseWalletFooterView) {
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        CGFloat cellHeight = 50.5;
        _chooseWalletFooterView = [[[NSBundle mainBundle] loadNibNamed:@"BBLoginChooseWalletFooterView" owner:nil options:nil] firstObject];
        _chooseWalletFooterView.frame = CGRectMake(0, 35+ allLocalWallet.count * cellHeight, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERVIEW_HEIGHT-35-allLocalWallet.count * cellHeight);
        _chooseWalletFooterView.delegate = self;
    }
    return _chooseWalletFooterView;
}

- (UIView *)chooseWalletBackgroundView{
    if (!_chooseWalletBackgroundView) {
        _chooseWalletBackgroundView = [[UIView alloc] init];
        NSArray *allLocalWallet = [[WalletTableManager walletTable] selectAllLocalWallet];
        
        CGFloat cellHeight = 50.5;
        
        _chooseWalletBackgroundView.frame = CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERVIEW_HEIGHT);
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0x999999);
        label.text = NSLocalizedString(@"请选择钱包:", nil);
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
            if (i == 0) {
                btn.selected = YES;
                self.choosed_wallet_id = [NSString stringWithFormat:@"%ld", (long)btn.tag];
            }else{
                btn.selected = NO;
            }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!IsNilOrNull(self.chooseWalletBackgroundView)) {
        [self.chooseWalletBackgroundView removeFromSuperview];
        self.chooseWalletBackgroundView = nil;
        [self.chooseWalletFooterView removeFromSuperview];
        self.chooseWalletFooterView = nil;
        
        NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
        if (localWalletsArr.count > 0) {
            [self.mainScrollView1 addSubview:self.chooseWalletBackgroundView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [LEETheme startTheme:BLACKBOX_MODE];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView1];
    [self.mainScrollView1 addSubview:self.loginHeaderView];
    if ([DeviceType getIsIpad]) {
        self.mainScrollView1.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+HEADERVIEW_HEIGHT);
    }
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    if (localWalletsArr.count > 0) {
        [self.mainScrollView1 addSubview:self.chooseWalletBackgroundView];
    }else{
        [self.mainScrollView1 addSubview:self.createWalletView];
    }
    
}


// BBLoginHeaderViewDelegate
-(void)changeModeToSocialMode{
    LoginEntranceViewController *vc = [[LoginEntranceViewController alloc] init];
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
        [TOASTVIEW showWithText:NSLocalizedString(@"请勾选同意条款!", nil)];
        return;
    }
    
    
    if (IsStrEmpty(self.createWalletView.walletNameTF.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"钱包名称不能为空!", nil)];
        return;
    }
    if (IsStrEmpty(self.createWalletView.passwordTF.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码不能为空!", nil)];
        return;
    }
    if (![self.createWalletView.confirmPasswordTF.text isEqualToString:self.createWalletView.passwordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"两次输入的密码不一致!", nil)];
        return;
    }
    // 查重该钱包名称已在您本地存在,请更换尝试~
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *model in localWalletsArr) {
        if ([model.wallet_name isEqualToString:self.createWalletView.walletNameTF.text]) {
            [TOASTVIEW showWithText:NSLocalizedString(@"该钱包名称已在您本地存在,请更换尝试~!", nil)];
            return;
        }
    }
    // 如果本地没有钱包
    Wallet *model = [[Wallet alloc] init];
    model.wallet_name = self.createWalletView.walletNameTF.text;
    
    model.wallet_shapwd = [WalletUtil generate_wallet_shapwd_withPassword:self.createWalletView.passwordTF.text];
    model.wallet_uid = [model.wallet_name sha256];
    model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,model.wallet_uid];
    [[WalletTableManager walletTable] addRecord: model];
    [[NSUserDefaults standardUserDefaults] setObject: model.wallet_uid  forKey:Current_wallet_uid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 创建账号(本地数据库)
    AddAccountViewController *vc = [[AddAccountViewController alloc] init];
    vc.addAccountViewControllerFromMode = AddAccountViewControllerFromLoginPage;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)explainBlackBoxModeBtnDidClick{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"SpecificationBlackBoxMode";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSProtocol";
   
    
    [self.navigationController pushViewController:vc animated:YES];
}


//BBLoginChooseWalletFooterViewDelegate
- (void)confirmBtnDidClick{
    if (self.chooseWalletFooterView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请勾选同意条款!", nil)];
        return;
    }
    NSArray *localWalletArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *wallet in localWalletArr) {
        if ([wallet.ID isEqualToString:self.choosed_wallet_id]) {
            [[NSUserDefaults standardUserDefaults] setObject: wallet.wallet_uid  forKey:Current_wallet_uid];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"%@", wallet.account_info_table_name);
            
            NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
            if (accountArray.count > 0) {
                // 如果本地有当前账号对应的钱包
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
                
            }else{
                AddAccountViewController *vc = [[AddAccountViewController alloc] init];
                vc.addAccountViewControllerFromMode = AddAccountViewControllerFromLoginPage;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
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
    vc.title = @"黑匣子模式";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
