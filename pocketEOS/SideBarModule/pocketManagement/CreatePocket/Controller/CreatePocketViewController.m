//
//  CreatePocketViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/4.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CreatePocketViewController.h"
#import "CreateAccountViewController.h"
#import "WalletTableManager.h"
#import "Wallet.h"
#import "ImportPocketViewController.h"
#import "CreatePocketHeaderView.h"
#import "NavigationView.h"
#import "RtfBrowserViewController.h"


@interface CreatePocketViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, CreatePocketHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) CreatePocketHeaderView *headerView;
@property(nonatomic , strong) UIButton *importPocketBtn;
@end

@implementation CreatePocketViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"创建钱包" rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (CreatePocketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CreatePocketHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 400);
    }
    return _headerView;
}

- (UIButton *)importPocketBtn{
    if (!_importPocketBtn) {
        _importPocketBtn = [[UIButton alloc] init];
        [_importPocketBtn addTarget:self action:@selector(importPocket:) forControlEvents:(UIControlEventTouchUpInside)];
        NSMutableAttributedString *tncString = [[NSMutableAttributedString alloc] initWithString:@"如果已有钱包，请点击这里导入"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x4D7BFE)  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [tncString length])];
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:HEXCOLOR(0x4D7BFE) range:(NSRange){0,[tncString length]}];
        [_importPocketBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    }
    return _importPocketBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
//    [self.view addSubview:self.importPocketBtn];
//    self.importPocketBtn.sd_layout.leftSpaceToView(self.view, MARGIN_20).rightSpaceToView(self.view, MARGIN_20).bottomSpaceToView(self.view, MARGIN_20).heightIs(20);
}

//  NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//CreatePocketHeaderViewDelegate
-(void)createPocketBtnDidClick:(UIButton *)sender{
    if (self.headerView.agreeTermBtn.isSelected) {
        [TOASTVIEW showWithText:@"请勾选同意条款!"];
        return;
    }
    if (IsStrEmpty(self.headerView.nameTF.text)) {
        [TOASTVIEW showWithText:@"钱包名称不能为空!"];
        return;
    }
    if (IsStrEmpty(self.headerView.passwordTF.text)) {
        [TOASTVIEW showWithText:@"密码不能为空!"];
        return;
    }
    if (![self.headerView.confirmPasswordTF.text isEqualToString:self.headerView.passwordTF.text]) {
        [TOASTVIEW showWithText:@"两次输入的密码不一致!"];
        return;
    }
    
    // 查重本地钱包名不可重复
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *model in localWalletsArr) {
        if ([model.wallet_name isEqualToString:self.headerView.nameTF.text]) {
            [TOASTVIEW showWithText:@"本地钱包名不可重复!"];
            return;
        }
    }
    if (self.createPocketViewControllerFromMode == CreatePocketViewControllerFromSocialMode) {
        // 已有钱包
        NSString *randomStr = [NSString randomStringWithLength:32];
        NSString *encryptStr = [NSString stringWithFormat:@"%@%@", randomStr,self.headerView.confirmPasswordTF.text];
        NSString *password_sha256 = [encryptStr sha256];
        NSString *savePassword = [NSString stringWithFormat:@"%@%@", randomStr,password_sha256];
        
        [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_shapwd = '%@',wallet_name = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , savePassword , self.headerView.nameTF.text, CURRENT_WALLET_UID]];
        
    }else if (self.createPocketViewControllerFromMode == CreatePocketViewControllerFromBlackBoxMode){
        // 重新创建钱包
        // 如果本地没有钱包
        Wallet *model = [[Wallet alloc] init];
        model.wallet_name = self.headerView.nameTF.text;
        model.wallet_shapwd = [self.headerView.passwordTF.text sha256];
        model.wallet_uid = [model.wallet_name sha256];
        model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
        [[NSUserDefaults standardUserDefaults] setObject: model.wallet_uid  forKey:Current_wallet_uid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[WalletTableManager walletTable] addRecord: model];
    }
    
    
    
    CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
    vc.createAccountViewControllerFromVC = CreateAccountViewControllerFromCreatePocketVC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)privacyPolicyBtnDidClick:(UIButton *)sender{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PocketEOSPrivacyPolicy";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)importPocket:(UIButton *)sender {
    ImportPocketViewController *vc = [[ImportPocketViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
