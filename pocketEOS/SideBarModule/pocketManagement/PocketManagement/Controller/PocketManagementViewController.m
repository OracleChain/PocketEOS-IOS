//
//  PocketManagementViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PocketManagementViewController.h"
#import "NavigationView.h"
#import "CreateAccountViewController.h"
#import "ImportAccountViewController.h"
#import "BackupPocketView.h"
#import "AccountManagementViewController.h"
#import "PocketManagementTableViewCell.h"
#import "PocketManagementServiceTableViewCell.h"
#import "ChangePasswordView.h"



@interface PocketManagementViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, BackupPocketViewDelegate, UIDocumentInteractionControllerDelegate, ChangePasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) BackupPocketView *backupPocketView;
@property(nonatomic, strong) ChangePasswordView *changePasswordView;
@property (nonatomic ,retain)UIDocumentInteractionController *documentController;
@end

@implementation PocketManagementViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"钱包管理", nil) rightBtnTitleName:NSLocalizedString(@"安全说明", nil) delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}


- (BackupPocketView *)backupPocketView{
    if (!_backupPocketView) {
        _backupPocketView = [[[NSBundle mainBundle] loadNibNamed:@"BackupPocketView" owner:nil options:nil] firstObject];
        _backupPocketView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _backupPocketView.delegate = self;
        
        
    }
    return _backupPocketView;
}
- (ChangePasswordView *)changePasswordView{
    if (!_changePasswordView) {
        _changePasswordView = [[[NSBundle mainBundle] loadNibNamed:@"ChangePasswordView" owner:nil options:nil] firstObject];
        _changePasswordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _changePasswordView.delegate = self;
    }
    return _changePasswordView;
}

- (PocketManagementService *)mainService{
    if (!_mainService) {
        _mainService = [[PocketManagementService alloc] init];
    }
    return _mainService;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self buildDataSource];
}

- (void)buildDataSource{ 
    WS(weakSelf);
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PocketManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
        if (!cell) {
            cell = [[PocketManagementTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
        }
        AccountInfo *model;
        if (indexPath.row == 0) {
            model = [[self.mainService.dataDictionary objectForKey:@"mainAccount"] firstObject];
        }else{
            model = [self.mainService.dataDictionary objectForKey:@"othersAccount"][indexPath.row-1];
        }
        cell.model = model;
        return cell;
    }else if (indexPath.section == 1){
        PocketManagementServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
        if (!cell) {
            cell = [[PocketManagementServiceTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEUDENTIFIER1];
        }
        OptionModel *model = [self.mainService.dataDictionary objectForKey:@"servicesArr"][indexPath.row];
        cell.model = model;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *arr = [self.mainService.dataDictionary objectForKey:@"othersAccount"];
        return arr.count + 1;
    }else if (section == 1){
       NSArray *arr = [self.mainService.dataDictionary objectForKey:@"servicesArr"];
        return arr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else if(indexPath.section == 1){
        return 45;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return MARGIN_10;
    }else if (section == 1){
        return MARGIN_20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AccountInfo *model;
        if (indexPath.row == 0) {
            model = [[self.mainService.dataDictionary objectForKey:@"mainAccount"] firstObject];
        }else{
            NSArray *accountArray = [self.mainService.dataDictionary objectForKey:@"othersAccount"];
            model = accountArray[indexPath.row-1];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeAccountCellDidClick:)]) {
            [self.delegate changeAccountCellDidClick:model.account_name];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (indexPath.section == 1){
        OptionModel *model = [self.mainService.dataDictionary objectForKey:@"servicesArr"][indexPath.row];
        if ([model.optionName isEqualToString:NSLocalizedString(@"创建账号", nil)]) {
            [self createAccountBtnDidClick];
        }else if ([model.optionName isEqualToString:NSLocalizedString(@"导入账号", nil)]){
            [self importAccountBtnDidClick];
        }else if ([model.optionName isEqualToString:NSLocalizedString(@"修改密码", nil)]){
            [self.view addSubview:self.changePasswordView];
        }else if ([model.optionName isEqualToString:NSLocalizedString(@"备份钱包", nil)]){
            [self backupPocketBtnDidClick];
        }
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
    vc.rtfFileName = @"PockSecureDecalre";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createAccountBtnDidClick{
    CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
    vc.createAccountViewControllerFromVC = CreateAccountViewControllerFromPocketManagementVC;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)importAccountBtnDidClick{
    ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)backupPocketBtnDidClick{
    [self.view addSubview:self.backupPocketView];
    Wallet *wallet = CURRENT_WALLET;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取当前时间
    NSDate *dateNow = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:dateNow];
    self.backupPocketView.backupPocketTitleLabel.text = [NSString stringWithFormat: @"%@%@%@", VALIDATE_STRING(wallet.wallet_name), NSLocalizedString(@"的钱包", nil), dateStr];
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //获取文件路径
    NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.txt",self.backupPocketView.backupPocketTitleLabel.text]];
    NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
    wallet.account_info = [NSMutableArray arrayWithArray:accountsArr];
    NSString *wallet_json = wallet.mj_JSONString;
    [wallet_json writeToFile:theFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void)changePasswordBtnDidClick{
    [self.view addSubview:self.changePasswordView];
}

//BackupPocketViewDelegate
- (void)iconImgDidTap:(UIGestureRecognizer *)sender{
    //获取沙盒路径
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //获取文件路径
   NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.txt",self.backupPocketView.backupPocketTitleLabel.text]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:theFilePath]) {
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:theFilePath]];
        self.documentController.delegate = self;
        
        // 预览
        //    [self.documentController presentPreviewAnimated:YES];
        
        // 不展示可选操作
        //    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
        
        // 展示可选操作
        [self.documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        
    }
}


- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

//ChangePasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self remove_change_passwordView];
}

- (void)confirmPasswordBtnDidClick:(UIButton *)sender{
    // 校验输入
    if (IsStrEmpty(self.changePasswordView.oraginalPasswordTF.text) || IsStrEmpty(self.changePasswordView.confirmPasswordTF.text) || IsStrEmpty(self.changePasswordView.inputNewPasswordTF.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"输入不能为空!", nil)];
        return;
    }
    
    if (![self.changePasswordView.inputNewPasswordTF.text isEqualToString:self.changePasswordView.confirmPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"两次输入的密码不一致!", nil)];
        return;
    }
    
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.changePasswordView.oraginalPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"原始密码输入有误!", nil)];
        [self remove_change_passwordView];
        return;
    }
    [self changeWalletPassword];
}

- (void)changeWalletPassword{
    NSArray *allLocalAccount = [[AccountsTableManager accountTable] selectAccountTable];
    Wallet *wallet = CURRENT_WALLET;
    for (AccountInfo *model in allLocalAccount) {
        NSString *decrypt_active_private_key = [AESCrypt decrypt:model.account_active_private_key password:self.changePasswordView.oraginalPasswordTF.text];
        NSString *decrypt_owner_private_key = [AESCrypt decrypt:model.account_owner_private_key password:self.changePasswordView.oraginalPasswordTF.text];
        
        NSString *encrypt_active_private_key = [AESCrypt encrypt:decrypt_active_private_key password:self.changePasswordView.confirmPasswordTF.text];
        NSString *encrypt_owner_private_key = [AESCrypt encrypt:decrypt_owner_private_key password:self.changePasswordView.confirmPasswordTF.text];
  
        // update table
       BOOL result = [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat: @"UPDATE '%@' SET account_active_private_key = '%@', account_owner_private_key = '%@'  WHERE account_name = '%@'", wallet.account_info_table_name, encrypt_active_private_key, encrypt_owner_private_key , model.account_name]];
        if (result) {
            NSLog(@"changeWalletPassword Success");
        }
    }
    
    // 验证通过, 修改密码
    BOOL result = [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_shapwd = '%@' WHERE wallet_uid = '%@'",  WALLET_TABLE, [WalletUtil generate_wallet_shapwd_withPassword:self.changePasswordView.confirmPasswordTF.text], CURRENT_WALLET_UID]];
    if (result) {
        [TOASTVIEW showWithText:NSLocalizedString(@"修改密码成功!", nil)];
    }
    [self remove_change_passwordView];
}


- (void)remove_change_passwordView{
    [self.changePasswordView removeFromSuperview];
    self.changePasswordView = nil;
}

@end
