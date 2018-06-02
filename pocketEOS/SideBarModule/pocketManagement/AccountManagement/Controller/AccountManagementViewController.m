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
#import "SetMainAccountRequest.h"
#import "SliderVerifyView.h"
#import "LoginPasswordView.h"
#import "AskQuestionTipView.h"
#import "AppDelegate.h"
#import "LoginMainViewController.h"
#import "SocialSharePanelView.h"
#import "SocialManager.h"
#import "SocialShareModel.h"

@interface AccountManagementViewController ()<UIGestureRecognizerDelegate,  NavigationViewDelegate, AccountManagementHeaderViewDelegate, ExportPrivateKeyViewDelegate, SliderVerifyViewDelegate, LoginPasswordViewDelegate, AskQuestionTipViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic, strong) AccountManagementHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ExportPrivateKeyView *exportPrivateKeyView;
@property(nonatomic, strong) SetMainAccountRequest *setMainAccountRequest;
@property(nonatomic, strong) SliderVerifyView *sliderVerifyView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) UILabel *tipLabel;
// export privateKey and delete account action need mark off
@property(nonatomic, copy) NSString *currentAction;
@property(nonatomic, strong) AskQuestionTipView *askQuestionTipView;
@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@end

@implementation AccountManagementViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"" rightBtnImgName:@"share" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (AccountManagementHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AccountManagementHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 408);
        _headerView.delegate = self;
    }
    return _headerView;
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
        _sliderVerifyView.tipLabel.text = @"滑动删除账号";
        _sliderVerifyView.delegate = self;
    }
    return _sliderVerifyView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.text = @"将滑块滑动到右侧指定位置内即可解锁";
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

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.backgroundColor = HEXCOLOR(0xF7F7F7);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[@"微信好友",@"朋友圈", @"QQ好友", @"QQ空间"];
        for (int i = 0; i < 4; i++) {
            SocialShareModel *model = [[SocialShareModel alloc] init];
            model.platformName = titleArr[i];
            model.platformImage = self.platformNameArr[i];
            [modelArr addObject:model];
        }
        self.socialSharePanelView.imageTopSpace = 15;
        [_socialSharePanelView updateViewWithArray:modelArr];
    }
    return _socialSharePanelView;
}

- (NSArray *)platformNameArr{
    if (!_platformNameArr) {
        _platformNameArr = @[@"wechat_friends",@"wechat_moments", @"qq_friends", @"qq_Zone"];
    }
    return _platformNameArr;
}

- (UIView *)shareBaseView{
    if (!_shareBaseView) {
        _shareBaseView = [[UIView alloc] init];
        _shareBaseView.userInteractionEnabled = YES;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor blackColor];
        topView.alpha = 0.5;
        topView.userInteractionEnabled = YES;
        [_shareBaseView addSubview:topView];
        topView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).topSpaceToView(_shareBaseView, 0).heightIs(SCREEN_HEIGHT - 47 - 100 - 50);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [topView addGestureRecognizer:tap];
        
        UIButton *cancleBtn = [[UIButton alloc] init];
        [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancleBtn setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [cancleBtn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
        [cancleBtn addTarget:self action:@selector(cancleShareAccountDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareBaseView addSubview:cancleBtn];
        cancleBtn.sd_layout.leftSpaceToView(_shareBaseView ,0 ).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_shareBaseView, 0).heightIs(47);
        
        [_shareBaseView addSubview:self.socialSharePanelView];
        _socialSharePanelView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(cancleBtn, 0).heightIs(100);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"    将二维码分享到";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEXCOLOR(0x2A2A2A);
        [label setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [_shareBaseView addSubview: label];
        label.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_socialSharePanelView, 0).heightIs(50);
        
    }
    return _shareBaseView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.navView.titleLabel.text = self.model.account_name;
    [self.view addSubview:self.sliderVerifyView];
   
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.sliderVerifyView.sd_layout.leftSpaceToView(self.view, 48).rightSpaceToView(self.view, 48).topSpaceToView(self.headerView, 26).heightIs(48);
        [self.view addSubview:self.tipLabel];
        self.tipLabel.sd_layout.leftSpaceToView(self.view, 20).rightSpaceToView(self.view, 20).topSpaceToView(self.sliderVerifyView, 10).heightIs(18);
       
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.headerView.mainAccountBtn.hidden = YES;
        self.headerView.exportPrivateKeyBtn.sd_layout.topSpaceToView(self.headerView.QRCodeImg, 66).leftSpaceToView(self.headerView, 48).rightSpaceToView(self.headerView, 48).heightIs(42);
         self.sliderVerifyView.sd_layout.leftSpaceToView(self.view, 48).rightSpaceToView(self.view, 48).topSpaceToView(self.headerView.exportPrivateKeyBtn, 90).heightIs(48);
        [self.view addSubview:self.tipLabel];
        self.tipLabel.sd_layout.leftSpaceToView(self.view, 20).rightSpaceToView(self.view, 20).topSpaceToView(self.sliderVerifyView, 10).heightIs(18);
        
        
        
    }
    
    
    
    
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VALIDATE_STRING(self.model.account_name)  forKey:@"account_name"];
    [dic setObject:VALIDATE_STRING(self.model.account_img)  forKey:@"account_img"];
    [dic setObject: @"account_QRCode" forKey:@"type"];
    //帐号二维码
    NSString *QRCodeJsonStr = [dic mj_JSONString];
    self.headerView.QRCodeImg.image  = [SGQRCodeGenerateManager generateWithLogoQRCodeData:QRCodeJsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
    
    
    AccountInfo *model = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.model.account_name];
    
    if ([model.is_main_account isEqualToString:@"1"]) {
        [self.headerView.mainAccountBtn setBackgroundColor: HEXCOLOR(0xCCCCCC)];
        self.headerView.mainAccountBtn.enabled = NO;
    } else {
        [self.headerView.mainAccountBtn setBackgroundColor:HEXCOLOR(0x4D7BFE )];
        self.headerView.mainAccountBtn.enabled = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//AccountManagementHeaderViewDelegate
- (void)setToMainAccountBtnDidClick:(UIButton *)sender{
    
    // 1.将所有的账号都设为 非主账号
    Wallet *wallet = CURRENT_WALLET;
    [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_main_account = '0' ", wallet.account_info_table_name]];
    // 2.将当前账号设为主账号
    BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET is_main_account = '1'  WHERE account_name = '%@'", wallet.account_info_table_name, self.model.account_name ]];
    if (result) {
        [TOASTVIEW showWithText:@"设置主账号成功!"];
    }
    // 3. 通知服务器
    self.setMainAccountRequest.uid = CURRENT_WALLET_UID;
    self.setMainAccountRequest.eosAccountName = self.model.account_name;
    [self.setMainAccountRequest postDataSuccess:^(id DAO, id data) {
        
    } failure:^(id DAO, NSError *error) {
        
    }];
    
}

- (void)exportPrivateKeyBtnDidClick:(UIButton *)sender{
    self.currentAction = @"ExportPrivateKey";
    [self.view addSubview:self.loginPasswordView];
}

// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
    self.currentAction = nil;
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:@"密码输入错误!"];
        return;
    }
    [self.loginPasswordView removeFromSuperview];
    if ([self.currentAction isEqualToString:@"ExportPrivateKey"]) {
        [self.view addSubview:self.exportPrivateKeyView];
        AccountInfo *model = [[AccountsTableManager accountTable] selectAccountTableWithAccountName: self.model.account_name];
        NSString *privateKeyStr = [NSString stringWithFormat:@"ACTIVEKEY：%@\nOWNKEY: %@\n", [AESCrypt decrypt:model.account_active_private_key password:self.loginPasswordView.inputPasswordTF.text], [AESCrypt decrypt:model.account_owner_private_key password:self.loginPasswordView.inputPasswordTF.text]];
        self.exportPrivateKeyView.contentTextView.text = privateKeyStr;
       
    }else if ([self.currentAction isEqualToString:@"DeleteAccount"]){
        // 删除账号
        NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
        if (accountArr.count > 1) {
            BOOL result = [[AccountsTableManager accountTable] executeUpdate: [NSString stringWithFormat:@"DELETE FROM '%@' WHERE account_name = '%@'", current_wallet.account_info_table_name,self.model.account_name]];
            if (result) {
                [TOASTVIEW showWithText:@"删除账号成功!"];
                [ self.navigationController popViewControllerAnimated:YES];
            }
        }else{ 
             [self.view addSubview:self.askQuestionTipView];
             self.askQuestionTipView.titleLabel.text = @"检测到您钱包下只有一个账号,继续将执行注销钱包操作!请谨慎~";
            
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
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginMainViewController alloc] init]];
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
    [TOASTVIEW showWithText:@"复制成功!"];
}

// NavigationViewDelegate
- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnDidClick{
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
}
// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    NSLog(@"%@", platformName);
    
    if ([platformName isEqualToString:@"wechat_friends"]) {
        [[SocialManager socialManager] wechatShareImageToScene:0 withImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        [[SocialManager socialManager] wechatShareImageToScene:1 withImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [[SocialManager socialManager] qqShareToScene:0 withShareImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [[SocialManager socialManager] qqShareToScene:1 withShareImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }
}

- (void)cancleShareAccountDetail{
    [self.shareBaseView removeFromSuperview];
}
- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}


@end
