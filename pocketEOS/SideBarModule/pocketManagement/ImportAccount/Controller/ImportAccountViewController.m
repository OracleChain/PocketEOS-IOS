//
//  ImportAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ImportAccountViewController.h"
#import "ImportAccountHeaderView.h"
#import "NavigationView.h"
#import "ScanQRCodeViewController.h"
#import "GetAccountRequest.h"
#import "GetAccountResult.h"
#import "GetAccount.h"
#import "Permission.h"
#import "EOS_Key_Encode.h"
#import "BackupEOSAccountService.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"

@interface ImportAccountViewController ()<UIGestureRecognizerDelegate,  UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, ImportAccountHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic, strong) ImportAccountHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic , strong) BackupEOSAccountService *backupEOSAccountService;
@end

@implementation ImportAccountViewController
{   // 从网络获取的公钥
    NSString *active_public_key_from_network;
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *active_public_key_from_local;
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
    BOOL private_active_Key_is_validate;
}
- (AccountPrivateKeyQRCodeModel *)model{
    if (!_model) {
        _model = [[AccountPrivateKeyQRCodeModel alloc] init];
    }
    return _model;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"导入账号", nil)rightBtnImgName:@"scan_black" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.rightBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"scan_black"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"scan"], UIControlStateNormal);
    }
    return _navView;
}

- (ImportAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImportAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 600);
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


- (BackupEOSAccountService *)backupEOSAccountService{
    if (!_backupEOSAccountService) {
        _backupEOSAccountService = [[BackupEOSAccountService alloc] init];
    }
    return _backupEOSAccountService;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.model) {
        self.headerView.accountNameTF.text = self.model.account_name;
        self.headerView.private_ownerKey_TF.text = self.model.owner_private_key;
        self.headerView.private_activeKey_tf.text = self.model.active_private_key;
    }
}

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerView];
}


// ImportAccountHeaderViewDelegate
- (void)importBtnDidClick:(UIButton *)sender{
    if (self.headerView.agreeTermBtn.isSelected == YES) {
        if (IsStrEmpty(self.headerView.accountNameTF.text)  ||IsStrEmpty(self.headerView.private_activeKey_tf.text)) {
            [TOASTVIEW showWithText:NSLocalizedString(@"输入框不能为空!", nil)];
            return;
        }else{
            [self.view addSubview:self.loginPasswordView];
        }
    }else{
        if (IsStrEmpty(self.headerView.accountNameTF.text)  ||IsStrEmpty(self.headerView.private_activeKey_tf.text)  || IsStrEmpty(self.headerView.private_ownerKey_TF.text)) {
            [TOASTVIEW showWithText:NSLocalizedString(@"输入框不能为空!", nil)];
            return;
        }else{
            [self.view addSubview:self.loginPasswordView];
        }
        
    }
}

- (void)agreeTermBtnDidClick:(UIButton *)sender{}


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
    
    // 检查本地是否有对应的账号
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.headerView.accountNameTF.text];
    if (accountInfo) {
        [TOASTVIEW showWithText:NSLocalizedString(@"本地钱包已存在该账号!", nil)];
        [self removeLoginPasswordView];
        return;
    }
    // 验证 account_name. owner_private_key , active_private_key 是否匹配
    [self validateInputFormat];
}




// 检查输入的格式
- (void)validateInputFormat{
    // 验证账号名私钥格式是否正确
    if (![RegularExpression validateEosAccountName:self.headerView.accountNameTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"12位字符，只能由小写字母a~z和数字1~5组成。", nil)];
        [self removeLoginPasswordView];
        return;
    }

    private_active_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.private_activeKey_tf.text];
    private_owner_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.private_ownerKey_TF.text ];
    
    
    if (self.headerView.agreeTermBtn.isSelected == YES) {
        if (private_active_Key_is_validate == YES) {
            [self createPublicKeys];
        }else{
            [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
            [self removeLoginPasswordView];
            return ;
        }
    }else{
        if ((private_owner_Key_is_validate == YES) && (private_active_Key_is_validate == YES)) {
            [self createPublicKeys];
        }else{
            [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
            [self removeLoginPasswordView];
            return ;
        }
    }
}


- (void)createPublicKeys{
    // 将用户导入的私钥生成公钥
   
    active_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.private_activeKey_tf.text];
    owner_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.private_ownerKey_TF.text];
    // 请求该账号的公钥
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(self.headerView.accountNameTF.text) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            
            for (Permission *permission in model.permissions) {
                if ([permission.perm_name isEqualToString:@"active"]) {
                    active_public_key_from_network = permission.required_auth_key;
                }else if ([permission.perm_name isEqualToString:@"owner"]){
                    owner_public_key_from_network = permission.required_auth_key;
                }
            }
            
            if (weakSelf.headerView.agreeTermBtn.isSelected == YES) {
                if ([active_public_key_from_network isEqualToString: active_public_key_from_local]) {
                    // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                    [weakSelf configAccountInfo];
                }else{
                    [TOASTVIEW showWithText:NSLocalizedString(@"导入的私钥不匹配!", nil)];
                }
            }else{
                if ([active_public_key_from_network isEqualToString: active_public_key_from_local] && [owner_public_key_from_network isEqualToString:owner_public_key_from_local]) {
                    // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                    [weakSelf configAccountInfo];
                }else{
                    [TOASTVIEW showWithText:NSLocalizedString(@"导入的私钥不匹配!", nil)];
                }
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// config account after import
- (void)configAccountInfo{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    accountInfo.account_name = self.headerView.accountNameTF.text;
    accountInfo.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
    accountInfo.account_active_public_key = active_public_key_from_local;
    accountInfo.account_active_private_key = [AESCrypt encrypt:self.headerView.private_activeKey_tf.text password:self.loginPasswordView.inputPasswordTF.text];
    if (self.headerView.agreeTermBtn.isSelected == YES) {
        accountInfo.account_owner_public_key = @"";
        accountInfo.account_owner_private_key = @"";
    }else{
        accountInfo.account_owner_public_key = owner_public_key_from_local;
        accountInfo.account_owner_private_key = [AESCrypt encrypt:self.headerView.private_ownerKey_TF.text password:self.loginPasswordView.inputPasswordTF.text];
    }
    accountInfo.is_privacy_policy = @"0";
    
    [[AccountsTableManager accountTable] addRecord:accountInfo];
    [WalletUtil setMainAccountWithAccountInfoModel:accountInfo];
    
    
    [TOASTVIEW showWithText:NSLocalizedString(@"导入账号成功!", nil)];
    self.backupEOSAccountService.backupEosAccountRequest.uid = CURRENT_WALLET_UID;
    self.backupEOSAccountService.backupEosAccountRequest.eosAccountName = accountInfo.account_name;
    [self.backupEOSAccountService backupAccount:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"备份到服务器成功!");
        }
    }];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
}


-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnDidClick {
    [self importWithQRCodeBtnDidClick:nil];
}

- (void)importWithQRCodeBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    // 1. 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(NSLocalizedString(@"用户第一次同意了访问相机权限 - - %@", nil), [NSThread currentThread]);
                }else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(NSLocalizedString(@"用户第一次拒绝了访问相机权限 - - %@", nil), [NSThread currentThread]);
                }
            }];
        }else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)message:NSLocalizedString(@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关", nil)preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertA];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(NSLocalizedString(@"因为系统原因, 无法访问相册", nil));
        }
    }else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)message:NSLocalizedString(@"未检测到您的摄像头", nil)preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    }
}
- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

@end
