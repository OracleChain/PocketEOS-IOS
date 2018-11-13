//
//  CreatePocketViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/4.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CreatePocketViewController.h"
#import "AddAccountViewController.h"
#import "WalletTableManager.h"
#import "Wallet.h"
#import "ImportPocketViewController.h"
#import "CreatePocketHeaderView.h"
#import "NavigationView.h"
#import "RtfBrowserViewController.h"
#import "PersonalSettingService.h"


@interface CreatePocketViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, CreatePocketHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) CreatePocketHeaderView *headerView;
@property(nonatomic , strong) UIButton *importPocketBtn;
@property(nonatomic , strong) PersonalSettingService *personalSettingService;
@end

@implementation CreatePocketViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"创建钱包", nil)rightBtnTitleName:@"" delegate:self];
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
        NSMutableAttributedString *tncString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"如果已有钱包，请点击这里导入", nil)];
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

- (PersonalSettingService *)personalSettingService{
    if (!_personalSettingService) {
        _personalSettingService = [[PersonalSettingService alloc] init];
    }
    return _personalSettingService;
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
        [TOASTVIEW showWithText:NSLocalizedString(@"请勾选同意条款!", nil)];
        return;
    }
    if (IsStrEmpty(self.headerView.nameTF.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"钱包名称不能为空!", nil)];
        return;
    }
    if (IsStrEmpty(self.headerView.passwordTF.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码不能为空!", nil)];
        return;
    }
    if (![self.headerView.confirmPasswordTF.text isEqualToString:self.headerView.passwordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"两次输入的密码不一致!", nil)];
        return;
    }
    
    // 查重该钱包名称已在您本地存在,请更换尝试~
    NSArray *localWalletsArr = [[WalletTableManager walletTable] selectAllLocalWallet];
    for (Wallet *model in localWalletsArr) {
        if ([model.wallet_name isEqualToString:self.headerView.nameTF.text]) {
            [TOASTVIEW showWithText:NSLocalizedString(@"该钱包名称已在您本地存在,请更换尝试~!", nil)];
            return;
        }
    }
    
   
    
    NSString *savePassword = [WalletUtil generate_wallet_shapwd_withPassword:self.headerView.confirmPasswordTF.text];
    if (self.createPocketViewControllerFromMode == CreatePocketViewControllerFromSocialMode) {
        // 已有钱包
        [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_shapwd = '%@',wallet_name = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , savePassword , self.headerView.nameTF.text, CURRENT_WALLET_UID]];
        
        self.personalSettingService.updateUserNameRequest.userName = self.headerView.nameTF.text;
        [self.personalSettingService.updateUserNameRequest postDataSuccess:^(id DAO, id data) {
            BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
            if ([result.code isEqualToNumber:@0]) {
                NSLog(@"通知服务器设置钱包名成功");
            }
            
        } failure:^(id DAO, NSError *error) {
            
        }];
        
    }else if (self.createPocketViewControllerFromMode == CreatePocketViewControllerFromBlackBoxMode){
        // 重新创建钱包
        // 如果本地没有钱包
        Wallet *model = [[Wallet alloc] init];
        model.wallet_name = self.headerView.nameTF.text;
        model.wallet_shapwd = savePassword;
        model.wallet_uid = [model.wallet_name sha256];
        [[NSUserDefaults standardUserDefaults] setObject: model.wallet_uid  forKey:Current_wallet_uid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
        [[WalletTableManager walletTable] addRecord: model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
