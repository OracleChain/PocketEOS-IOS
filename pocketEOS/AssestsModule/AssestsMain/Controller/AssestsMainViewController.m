//
//  AssestsMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AssestsMainViewController.h"
#import "AssestsDetailViewController.h"
#import "CustomNavigationView.h"
#import "AssestsMainHeaderView.h"
#import "SideBarViewController.h"
#import "TransferNewViewController.h"
#import "RecieveViewController.h"
#import "RedPacketViewController.h"
#import "ChangeAccountViewController.h"
#import "WalletTableManager.h"
#import "AccountsTableManager.h"
#import "AccountInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanQRCodeViewController.h"
#import "AssestsMainService.h"
#import "AccountResult.h"
#import "Account.h"
#import "AssestsMainTableViewCell.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "PersonalSettingViewController.h"
#import "PocketManagementViewController.h"
#import "AccountManagementViewController.h"
#import "AccountQRCodeManagementViewController.h"
#import "AppDelegate.h"
#import "Wallet.h"
#import "CQMarqueeView.h"
#import "UIView+frameAdjust.h"
#import "BaseTabBarController.h"
#import "AccountInfo.h"
#import "AdvertisementView.h"
#import "BPVoteViewController.h"
#import "CommonWKWebViewController.h"
#import "DAppDetailViewController.h"
#import "VersionUpdateTipView.h"
#import "VersionUpdateModel.h"
#import "GetVersionInfoRequest.h"
#import "AddAssestsViewController.h"
#import "Get_token_info_service.h"
#import "GetTokenInfoResult.h"
#import "TokenInfo.h"
#import "AccountNotExistView.h"
#import "MessageFeedbackViewController.h"
#import "GetAccountOrderStatusRequest.h"
#import "AccountOrderStatus.h"
#import "AccountOrderStatusResult.h"
#import "ExcuteMultipleActionsService.h"
#import "EOSResourceManageViewController.h"
#import "EOSResourceService.h"

@interface AssestsMainViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ChangeAccountViewControllerDelegate, CQMarqueeViewDelegate, AdvertisementViewDelegate, PocketManagementViewControllerDelegate, VersionUpdateTipViewDelegate, AddAssestsViewControllerDelegate, AccountNotExistViewDelegate>

@property(nonatomic, strong) CustomNavigationView *navView;
@property(nonatomic, strong) AssestsMainHeaderView *headerView;
@property(nonatomic, strong) AssestsMainService *mainService;
@property(nonatomic, strong) Get_token_info_service *get_token_info_service;
@property(nonatomic , strong) AdvertisementView *advertisementView;
@property(nonatomic , strong) AccountNotExistView *accountNotExistView;
@property(nonatomic , strong) AccountResult *currentAccountResult;
@property(nonatomic, strong) UIButton *inviteFriendBtn;
@property(nonatomic , strong) VersionUpdateTipView *versionUpdateTipView;
@property(nonatomic , strong) GetVersionInfoRequest *getVersionInfoRequest;
@property(nonatomic , strong) VersionUpdateModel *versionUpdateModel;
@property(nonatomic , strong) NSMutableArray *ids;
@property(nonatomic , strong) GetAccountOrderStatusRequest *getAccountOrderStatusRequest;
@property(nonatomic , strong) CAGradientLayer *gradientLayer;
@property(nonatomic , strong) EOSResourceService *eosResourceService;
@end

@implementation AssestsMainViewController


- (CustomNavigationView *)navView{
    if (!_navView) {
        _navView = [[CustomNavigationView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT))];
        if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
            _navView.rightBtn2.hidden = YES;
        }else{
            _navView.rightBtn2.hidden = NO;
        }
    }
    return _navView;
}

- (AssestsMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsMainHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 290);   
    }
    return _headerView;
}

- (AssestsMainService *)mainService{
    if (!_mainService) {
        _mainService = [[AssestsMainService alloc] init];
    }
    return _mainService;
}
- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (AdvertisementView *)advertisementView{
    if (!_advertisementView) {
        _advertisementView = [[[NSBundle mainBundle] loadNibNamed:@"AdvertisementView" owner:nil options:nil] firstObject];
        _advertisementView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TABBAR_HEIGHT);
        _advertisementView.delegate = self;
    }
    return _advertisementView;
}


- (AccountResult *)currentAccountResult{
    if (!_currentAccountResult) {
        _currentAccountResult = [[AccountResult alloc] init];
    }
    return _currentAccountResult;
}

- (UIButton *)inviteFriendBtn{
    if(!_inviteFriendBtn){
        _inviteFriendBtn = [[UIButton alloc] init];
        [_inviteFriendBtn setImage:[UIImage imageNamed:@"inviteFriend_icon"] forState:(UIControlStateNormal)];
        _inviteFriendBtn.layer.masksToBounds = YES;
        [_inviteFriendBtn addTarget: self action: @selector(inviteFriendBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _inviteFriendBtn;
}

- (VersionUpdateTipView *)versionUpdateTipView{
    if (!_versionUpdateTipView) {
        _versionUpdateTipView = [[VersionUpdateTipView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _versionUpdateTipView.delegate = self;
    }
    return _versionUpdateTipView;
}

- (AccountNotExistView *)accountNotExistView{
    if (!_accountNotExistView) {
        _accountNotExistView =  [[[NSBundle mainBundle] loadNibNamed:@"AccountNotExistView" owner:nil options:nil] firstObject];
        _accountNotExistView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT);
        _accountNotExistView.delegate = self;
    }
    return _accountNotExistView;
}
- (GetVersionInfoRequest *)getVersionInfoRequest{
    if (!_getVersionInfoRequest) {
        _getVersionInfoRequest = [[GetVersionInfoRequest alloc] init];
    }
    return _getVersionInfoRequest;
}

- (NSMutableArray *)ids{
    if (!_ids) {
        _ids = [[NSMutableArray alloc] init];
    }
    return _ids;
}

- (GetAccountOrderStatusRequest *)getAccountOrderStatusRequest{
    if (!_getAccountOrderStatusRequest) {
        _getAccountOrderStatusRequest = [[GetAccountOrderStatusRequest alloc] init];
    }
    return _getAccountOrderStatusRequest;
}

- (EOSResourceService *)eosResourceService{
    if (!_eosResourceService) {
        _eosResourceService = [[EOSResourceService alloc] init];
    }
    return _eosResourceService;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    Wallet *wallet = CURRENT_WALLET;
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        [_navView.leftBtn sd_setImageWithURL:nil forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"setting"]];
    }else{
        [_navView.leftBtn sd_setImageWithURL:wallet.wallet_img forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    }
    self.headerView.userAccountLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"当前账号", nil), VALIDATE_STRING(CURRENT_ACCOUNT_NAME) ] ;
    [self buidDataSource];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"";
    
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 290 );
    self.gradientLayer.startPoint = CGPointMake(1, 1);
    self.gradientLayer.endPoint = CGPointMake(0, 0);
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0x1667DF).CGColor, (__bridge id)HEXCOLOR(0x2E82FE).CGColor];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0x23242A).CGColor, (__bridge id)HEXCOLOR(0x282828).CGColor];
    }
    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
    [self.view.layer addSublayer:self.gradientLayer];
    
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.stateLabel.textColor = HEXCOLOR(0xFFFFFF);
    header.lastUpdatedTimeLabel.hidden = YES;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer.hidden = YES;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
    
   
    
    [self.mainTableView setTableHeaderView:self.headerView];
    [self loadAllBlocks];
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    if (accountArray.count == 1) {
        // 当前只有一个账号
        AccountInfo *model = accountArray[0];
        [[NSUserDefaults standardUserDefaults] setObject:model.account_name  forKey:Current_Account_name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.headerView.userAccountLabel.text = CURRENT_ACCOUNT_NAME;
    }else{
        for (AccountInfo *model in accountArray) {
            if ([model.is_main_account isEqualToString:@"1"]) {
                AccountInfo *mainAccount = model;
                [[NSUserDefaults standardUserDefaults] setObject:mainAccount.account_name  forKey:Current_Account_name];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.headerView.userAccountLabel.text = CURRENT_ACCOUNT_NAME;
            }
        }
    }
    
    [self loadNewData];
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    
    // 配置开屏广告
//    [self configAdvertisement];
//    [self addinviteFriendBtn];
    [self checkNewVersion];
    
    [self getAccount];
}

// 构建数据源
- (void)buidDataSource{
    WS(weakSelf);
    if (IsNilOrNull(CURRENT_ACCOUNT_NAME)) {
        return;
    }
    self.get_token_info_service.get_token_info_request.accountName = CURRENT_ACCOUNT_NAME;
    
    self.get_token_info_service.get_token_info_request.ids = self.ids;
    [self.get_token_info_service get_token_info:^(GetTokenInfoResult *result, BOOL isSuccess) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.mainTableView.mj_header endRefreshing];
        
            if ([result.code isEqualToNumber:@0] && [result.message isEqualToString:@"ok"]) {
                if (result.data.count == 0) {
                    [weakSelf.view addSubview:weakSelf.accountNotExistView];
                    weakSelf.accountNotExistView.tipLabel.text = [NSString stringWithFormat:@"%@ %@", CURRENT_ACCOUNT_NAME, NSLocalizedString(@"等待主网确认", nil)];
                }else{
                    [weakSelf removeAccountNotExistView];
                    [weakSelf.mainTableView reloadData];
                    [weakSelf.headerView updateViewWithDataArray:weakSelf.get_token_info_service.dataSourceArray];
                    //沙盒ducument目录
                    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    //完整的文件路径
                    NSString *path = [docPath stringByAppendingPathComponent:LOCAL_CURRENT_TOKEN_INFO_ARRAY_FILENAME];
                    
                   BOOL success = [NSKeyedArchiver archiveRootObject:weakSelf.get_token_info_service.dataSourceArray toFile:path];
                    
                    [weakSelf getAccount];
                }
            }
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +210);
        }];
 
    }];
}

- (void)loadAllBlocks{
    WS(weakSelf);
    // 默认的导航栏 block
    [self.navView setLeftBtnDidClickBlock:^{
        [weakSelf profileCenter];
        
    }];
   
    [self.navView setRightBtn1DidClickBlock:^{
        PocketManagementViewController *vc = [[PocketManagementViewController alloc] init];
        vc.delegate = weakSelf;
        vc.mainService.currentAccountName = CURRENT_ACCOUNT_NAME;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navView setRightBtn2DidClickBlock:^{
        
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
                vc.get_token_info_service_data_array = self.get_token_info_service.dataSourceArray;
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
    }];
    
    // 改变后的导航栏 block
    [self.navView setChangedBtn1DidClickBlock:^{
        TransferNewViewController *vc = [[TransferNewViewController alloc] init];
        vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
        vc.fromPage = @"AssestsMainViewController";
        vc.currentAssestsType = SymbolName_EOS;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navView setChangedBtn2DidClickBlock:^{
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navView setChangedBtn3DidClickBlock:^{
        RedPacketViewController *vc = [[RedPacketViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.headerView setChangeAccountBtnDidClickBlock:^{
        ChangeAccountViewController *vc = [[ChangeAccountViewController alloc] init];
        NSMutableArray *accountInfoArray = [[AccountsTableManager accountTable] selectAccountTable];
        vc.dataArray = accountInfoArray;
        vc.changeAccountDataArrayType = ChangeAccountDataArrayTypeLocal;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setTransferBtnDidClickBlock:^{
        
        TransferNewViewController *vc = [[TransferNewViewController alloc] init];
        vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
        vc.fromPage = @"AssestsMainViewController";
        vc.currentAssestsType = SymbolName_EOS;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setRecieveBtnDidClickBlock:^{
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setRedPacketBtnDidClickBlock:^{
        BOOL result = NO;
        for (TokenInfo *token in weakSelf.get_token_info_service.dataSourceArray) {
            if ([token.token_symbol isEqualToString:@"OCT"] || [token.token_symbol isEqualToString:@"EOS"]) {
                result = YES;
            }
        }
        if (result) {
            RedPacketViewController *vc = [[RedPacketViewController alloc] init];
            vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [TOASTVIEW showWithText: NSLocalizedString(@"请关注EOS或者OCT即可发送红包", nil)];
        }
    }];
    
    [self.headerView setRamTradeBtnDidClickBlock:^{
        EOSResourceManageViewController *vc = [[EOSResourceManageViewController alloc] init];
        vc.currentAccountName = CURRENT_ACCOUNT_NAME;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    
//        DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
//        Application *model = [[Application alloc] init];
//        model.url = @"http://static.pocketeos.top:3002";
////        model.url = @"https://dapp.newdex.io/";
////        model.url = @"https://coincreate.github.io/EOS_coincreate/coincreate_scatter.html";
//        model.applyName = @"EOS内存市场";
//        vc.model = model;
//        vc.choosedAccountName = CURRENT_ACCOUNT_NAME;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setAccountBtnDidTapBlock:^{
        [MobClick event:@"首页资产页点击账号名查看账号"];
        AccountQRCodeManagementViewController *vc = [[AccountQRCodeManagementViewController alloc] init];
        AccountInfo *model = [[AccountInfo alloc] init];
        model.account_name = CURRENT_ACCOUNT_NAME;
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setAvatarImgDidTapBlock:^{
        PersonalSettingViewController *vc = [[PersonalSettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setAddAssestsImgDidTapBlock:^{
        AddAssestsViewController *vc = [[AddAssestsViewController alloc] init];
        vc.accountName = CURRENT_ACCOUNT_NAME;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.get_token_info_service.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssestsMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[AssestsMainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellIdentifier"];
    }
    TokenInfo *model = self.get_token_info_service.dataSourceArray[indexPath.row];
    if ([model.asset_price_change_in_24h hasPrefix:@"-"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%%", model.asset_price_change_in_24h]];
        [attrString addAttribute:NSForegroundColorAttributeName
                        value:HEXCOLOR(0xB51515)
                        range:NSMakeRange(0, model.asset_price_change_in_24h.length +1)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }else{
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"+%@%%", model.asset_price_change_in_24h]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x1E903C)
                           range:NSMakeRange(0, model.asset_price_change_in_24h.length + 2)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }
    
    cell.model = model;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    CGPoint offset = scrollView.contentOffset;
//    NSLog(@"scrollViewDidScroll x:  %f, y:  %f", offset.x, offset.y);
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [self.headerView.assestHeaderButtonsBackgroundView convertRect: self.headerView.assestHeaderButtonsBackgroundView.bounds toView:window];
    self.gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH,NAVIGATIONBAR_HEIGHT + (rect.origin.y < NAVIGATIONBAR_HEIGHT ? NAVIGATIONBAR_HEIGHT : rect.origin.y ) + 100);
    
    if (scrollView.contentOffset.y >= 300) {
        // 隐藏 headerview
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.originNavView.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.navView.changedNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.inviteFriendBtn.hidden = YES;
        }];
    }else{
        // 显示 headerview
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.changedNavView.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.navView.originNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.inviteFriendBtn.hidden = NO;
            
        }];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssestsDetailViewController *vc = [[AssestsDetailViewController alloc] init];
    TokenInfo *model = self.get_token_info_service.dataSourceArray[indexPath.row];
    vc.model = model;
    vc.accountName = CURRENT_ACCOUNT_NAME;
    vc.get_token_info_service_data_array = self.get_token_info_service.dataSourceArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    [self profileCenter];
}

- (void)profileCenter{
    // 自己随心所欲创建的一个控制器
    SideBarViewController *vc = [[SideBarViewController alloc] init];
    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
    
    
}

//ChangeAccountViewControllerDelegate, PocketManagementViewControllerDelegate
-(void)changeAccountCellDidClick:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] setObject:VALIDATE_STRING(name)  forKey:Current_Account_name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.ids removeAllObjects];
    [self loadNewData];
}

- (void)loadNewData
{
    [self checkAccountOrderStatus];
}

- (void)checkAccountOrderStatus{
    WS(weakSelf);
    self.getAccountOrderStatusRequest.accountName = CURRENT_ACCOUNT_NAME;
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        self.getAccountOrderStatusRequest.uid = @"6f1a8e0eb24afb7ddc829f96f9f74e9d";
    }else{
        self.getAccountOrderStatusRequest.uid = CURRENT_WALLET_UID;
    }
    [self.getAccountOrderStatusRequest getDataSusscess:^(id DAO, id data) {
        AccountOrderStatusResult *result = [AccountOrderStatusResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            if ([result.data.createStatus isEqualToNumber:@1] || [result.data.createStatus isEqualToNumber:@5]) {
                [weakSelf buidDataSource];
            }else{
                [weakSelf.view addSubview:weakSelf.accountNotExistView];
                weakSelf.accountNotExistView.tipLabel.text = [NSString stringWithFormat:@"%@%@", result.data.accountName, result.data.message];
            }
            
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
        NSArray *tmpArr = [ArchiveUtil unarchiveTokenInfoArray];
        weakSelf.get_token_info_service.dataSourceArray = [NSMutableArray arrayWithArray:tmpArr];
        [weakSelf.mainTableView reloadData];
        [weakSelf.headerView updateViewWithDataArray:weakSelf.get_token_info_service.dataSourceArray];
        [weakSelf checkNetworkStatus];
    }];
}


//AdvertisementViewDelegate
- (void)goforwardDidClick{
    BPVoteViewController *vc = [[BPVoteViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.advertisementView removeFromSuperview];
}

- (void)configAdvertisement{
    [self.view addSubview:self.advertisementView];
    self.advertisementView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view bringSubviewToFront:self.advertisementView];
}

- (void)addinviteFriendBtn{
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        [self.view addSubview:self.inviteFriendBtn];
        self.inviteFriendBtn.sd_layout.rightSpaceToView(self.view, MARGIN_20).bottomSpaceToView(self.view, MARGIN_20 + TABBAR_HEIGHT).widthIs(69).heightIs(53);
    }
}

- (void)inviteFriendBtnClick{
    CommonWKWebViewController *vc = [[CommonWKWebViewController alloc] init];
    Wallet *wallet = CURRENT_WALLET;
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    vc.urlStr = @"http://static.pocketeos.top:3501";
    NSArray *cookieArr = [cookie componentsSeparatedByString:@";"];
    NSString *PE_cookieStr;
    if (cookieArr.count > 0) {
        PE_cookieStr = cookieArr[0];
    }
    NSString *finalCookie;
    if (PE_cookieStr.length > 10) {
        finalCookie = [PE_cookieStr substringFromIndex:10];
    }else{
        finalCookie = @"1";
    }
    vc.parameterStr =[NSString stringWithFormat:@"/#/index?phone=%@&validateCode=1&inviteCode=1&uid=%@&cookie=%@", wallet.wallet_phone, wallet.wallet_uid, finalCookie];
    vc.title = @"邀请计划";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkNewVersion{
    WS(weakSelf);
    [self.getVersionInfoRequest getDataSusscess:^(id DAO, id data) {
        weakSelf.versionUpdateModel = [VersionUpdateModel mj_objectWithKeyValues:data[@"data"]];
        if (weakSelf.versionUpdateModel.versionCode.integerValue > [weakSelf queryVersionNumberInBundle] ) {
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.versionUpdateTipView];
            [weakSelf.versionUpdateTipView setModel:weakSelf.versionUpdateModel];
        }else{
            
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

- (NSInteger)queryVersionNumberInBundle{
    
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    // 当前版本号
    NSString *currentVersionStr =  [infoDic valueForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return versionStr.integerValue;
}

//VersionUpdateTipViewDelegate
- (void)skipBtnDidClick:(UIButton *)sender{
    [self.versionUpdateTipView removeFromSuperview];
}

- (void)updateBtnDidClick:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://pocketeos.com"]];
}

//AddAssestsViewControllerDelegate
- (void)addAssestsViewControllerbackButtonDidClick:(NSMutableArray *)ids{
    self.ids = ids;
    [self loadNewData];
}

//AccountNotExistViewDelegate
- (void)checkAccountStatusBtnDidClick{
    [SVProgressHUD showWithStatus:nil];
    [self loadNewData];
}

- (void)contactUsLabelDidTap{
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        MessageFeedbackViewController *vc = [[MessageFeedbackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [TOASTVIEW showWithText:NSLocalizedString(@"请使用社交模式反馈错误，以便我们能与您取得联系", nil)];
    }
}

- (void)removeAccountNotExistView{
    if (self.accountNotExistView) {
        [self.accountNotExistView removeFromSuperview];
        self.accountNotExistView = nil;
    }
}


- (void)getAccount{
    WS(weakSelf);
    self.eosResourceService.getAccountRequest.name = CURRENT_ACCOUNT_NAME;
    [self.eosResourceService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.headerView updateViewWithEOSResourceResult:result];
        }
        
    }];
    
}

- (void)checkNetworkStatus{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络状态未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
                [SVProgressHUD showImage:[UIImage imageNamed:@"network_error_white"] status:NSLocalizedString(@"网络已断开\n请检查网络", nil)];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotReachable" object:nil];
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G蜂窝移动网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

@end
