//
//  PocketManagementViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/11.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PocketManagementViewController.h"
#import "PocketManagementHeaderView.h"
#import "NavigationView.h"
#import "CreateAccountViewController.h"
#import "ImportAccountViewController.h"
#import "BackupPocketView.h"
#import "AccountManagementViewController.h"
#import "PocketManagementTableViewCell.h"
#import "PocketManagementService.h"
#import "ChangePasswordView.h"
#import "AccountPravicyProtectionRequest.h"


@interface PocketManagementViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, PocketManagementHeaderViewDelegate, BackupPocketViewDelegate, UIDocumentInteractionControllerDelegate, ChangePasswordViewDelegate>
@property(nonatomic, strong) NavigationView *navView;

@property(nonatomic, strong) PocketManagementHeaderView *headerView;
@property(nonatomic, strong) BackupPocketView *backupPocketView;
@property(nonatomic, strong) ChangePasswordView *changePasswordView;
@property(nonatomic, strong) PocketManagementService *mainService;
@property(nonatomic, strong) AccountPravicyProtectionRequest *accountPravicyProtectionRequest;

@property (nonatomic ,retain)UIDocumentInteractionController *documentController;
@end

@implementation PocketManagementViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"钱包管理" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (PocketManagementHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"PocketManagementHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 311);
        _headerView.delegate = self;
    }
    return _headerView;
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

- (AccountPravicyProtectionRequest *)accountPravicyProtectionRequest{
    if (!_accountPravicyProtectionRequest) {
        _accountPravicyProtectionRequest = [[AccountPravicyProtectionRequest alloc] init];
    }
    return _accountPravicyProtectionRequest;
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
    [self.mainTableView setTableHeaderView:self.headerView];
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
    PocketManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[PocketManagementTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }

    WS(weakSelf);
    AccountInfo *model;
    if (indexPath.section == 0) {
        model = [[self.mainService.dataDictionary objectForKey:@"mainAccount"] firstObject];
    }else if (indexPath.section == 1){
        model = [self.mainService.dataDictionary objectForKey:@"othersAccount"][indexPath.row];
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"保护隐私" backgroundColor:HEXCOLOR(0xFABB17) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            weakSelf.accountPravicyProtectionRequest.eosAccountName = model.account_name;
            if ([model.is_privacy_policy isEqualToString:@"0"]) {
                weakSelf.accountPravicyProtectionRequest.status = @1;
            }else if ([model.is_privacy_policy isEqualToString:@"1"]){
                weakSelf.accountPravicyProtectionRequest.status = @0;
            }
            [weakSelf.accountPravicyProtectionRequest postDataSuccess:^(id DAO, id data) {
                if ([data[@"code"] isEqual:@0]) {
                    Wallet *wallet = CURRENT_WALLET;
                    [[AccountsTableManager accountTable] executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET is_privacy_policy = '%@' WHERE account_name = '%@'" , wallet.account_info_table_name , [NSString stringWithFormat:@"%@" , weakSelf.accountPravicyProtectionRequest.status]  , model.account_name]];
                    model.is_privacy_policy = [NSString stringWithFormat:@"%@" , weakSelf.accountPravicyProtectionRequest.status];
                    [weakSelf.mainTableView reloadData];
                }else{
                    [TOASTVIEW showWithText:data[@"message"]];
                }
            } failure:^(id DAO, NSError *error) {
                
            }];
            return YES;
        }]];
    }
    cell.model = model;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainService.dataDictionary.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *arr = [self.mainService.dataDictionary objectForKey:@"mainAccount"];
        return arr.count;
    }else if (section == 1){
       NSArray *arr = [self.mainService.dataDictionary objectForKey:@"othersAccount"];
        return arr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 58;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        BaseView *headerView = [[BaseView alloc] init];
        BaseSlimLineView *line1 = [[BaseSlimLineView alloc] init];
        line1.frame = CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_LINE_HEIGHT);
        BaseLabel *label = [[BaseLabel alloc] init];
        label.text = [NSString stringWithFormat:@"    其他账号"];
        label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 48);
        
        label.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:label];
        [headerView addSubview:line1];
        
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountInfo *model;
    if (indexPath.section == 0) {
        model = [[self.mainService.dataDictionary objectForKey:@"mainAccount"] firstObject];
    }else if (indexPath.section == 1){
        model = [self.mainService.dataDictionary objectForKey:@"othersAccount"][indexPath.row];
    }
    AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createAccountBtnDidClick:(UIButton *)sender{
    CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
    vc.createAccountViewControllerFromVC = CreateAccountViewControllerFromPocketManagementVC;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)importAccountBtnDidClick:(UIButton *)sender{
    ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)backupPocketBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.backupPocketView];
    Wallet *wallet = CURRENT_WALLET;
    self.backupPocketView.backupPocketTitleLabel.text = [NSString stringWithFormat:@"%@的钱包",  wallet.wallet_name];
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //获取文件路径
    NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"wallet_Backup.txt"];
    
    NSMutableArray *accountsArr = [[AccountsTableManager accountTable] selectAccountTable];
    wallet.account_info = [NSMutableArray arrayWithArray:accountsArr];
    NSString *wallet_json = wallet.mj_JSONString;
    [wallet_json writeToFile:theFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void)changePasswordBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.changePasswordView];
}
- (void)mainAccountBtnDidClick:(UIButton *)sender{
    AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//BackupPocketViewDelegate
- (void)iconImgDidTap:(UIGestureRecognizer *)sender{
    //获取沙盒路径
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //获取文件路径
    NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"wallet_Backup.txt"];
    
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
    [self.changePasswordView removeFromSuperview];
    self.changePasswordView = nil;
}

- (void)confirmPasswordBtnDidClick:(UIButton *)sender{
    // 校验输入
    if (IsStrEmpty(self.changePasswordView.oraginalPasswordTF.text) || IsStrEmpty(self.changePasswordView.confirmPasswordTF.text) || IsStrEmpty(self.changePasswordView.inputNewPasswordTF.text)) {
        [TOASTVIEW showWithText:@"输入不能为空!"];
        return;
    }
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.changePasswordView.oraginalPasswordTF.text]) {
        [TOASTVIEW showWithText:@"原始密码输入有误!"];
        return;
    }
    
    if (![self.changePasswordView.inputNewPasswordTF.text isEqualToString:self.changePasswordView.confirmPasswordTF.text]) {
        [TOASTVIEW showWithText:@"两次输入的密码不一致!"];
        return;
    }
    
    // 验证通过, 修改密码
   BOOL result = [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_shapwd = '%@' WHERE wallet_uid = '%@'",  WALLET_TABLE, [self.changePasswordView.inputNewPasswordTF.text sha256], CURRENT_WALLET_UID]];
    if (result) {
        [TOASTVIEW showWithText:@"修改密码成功!"];
    }
    
    [self cancleBtnDidClick:nil];
}
@end
