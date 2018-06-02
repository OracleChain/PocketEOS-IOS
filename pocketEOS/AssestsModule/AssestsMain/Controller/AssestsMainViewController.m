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
#import "BBAssestsMainHeaderView.h"
#import "SideBarViewController.h"
#import "TransferViewController.h"
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
#import "AccountManagementViewController.h"
#import "LoginMainViewController.h"
#import "AppDelegate.h"
#import "Wallet.h"
#import "CQMarqueeView.h"
#import "UIView+frameAdjust.h"
#import "CreateAccountViewController.h"
#import "PopUpWindow.h"
#import "BaseTabBarController.h"
#import "AccountInfo.h"

@interface AssestsMainViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ChangeAccountViewControllerDelegate, CQMarqueeViewDelegate, PopUpWindowDelegate>

@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) CustomNavigationView *navView;
@property(nonatomic, strong) AssestsMainHeaderView *headerView;
@property(nonatomic, strong) BBAssestsMainHeaderView *BB_headerView;
@property(nonatomic, strong) AssestsMainService *mainService;
@property(nonatomic, strong) NSString *currentAccountName;


/**
 当前选中的 账号
 */
@property(nonatomic, strong) UILabel *currentAssestsLabel;

/**
 箭头
 */
@property(nonatomic, strong) UIImageView *arrowImg;
@property(nonatomic, strong) PopUpWindow *popUpWindow;

@end

@implementation AssestsMainViewController

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 333);
            
        }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 248);
        }
        _backgroundView.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, RGB(65, 115, 238))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    }
    return _backgroundView;
}


- (CustomNavigationView *)navView{
    if (!_navView) {
        _navView = [[CustomNavigationView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT))];
    }
    return _navView;
}

- (AssestsMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsMainHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 333);
        
        
    }
    return _headerView;
}

- (BBAssestsMainHeaderView *)BB_headerView{
    if (!_BB_headerView) {
        _BB_headerView = [[[NSBundle mainBundle] loadNibNamed:@"BBAssestsMainHeaderView" owner:nil options:nil] firstObject];
        _BB_headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 248);
    }
    return _BB_headerView;
}

- (AssestsMainService *)mainService{
    if (!_mainService) {
        _mainService = [[AssestsMainService alloc] init];
    }
    return _mainService;
}

- (UILabel *)currentAssestsLabel{
    if (!_currentAssestsLabel) {
        _currentAssestsLabel = [[UILabel alloc] init];
        _currentAssestsLabel.textColor = [UIColor whiteColor];
        _currentAssestsLabel.font = [UIFont systemFontOfSize:13];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCurrentAssestsLabel:)];
        [_currentAssestsLabel addGestureRecognizer:tap];
        _currentAssestsLabel.userInteractionEnabled = YES;
        
    }
    return _currentAssestsLabel;
}


- (UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"downImg"];
        _arrowImg.userInteractionEnabled = YES;
    }
    return _arrowImg;
}

- (PopUpWindow *)popUpWindow{
    if (!_popUpWindow) {
        _popUpWindow = [[PopUpWindow alloc] initWithFrame:(CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT ))];
        _popUpWindow.delegate = self;
        WS(weakSelf);
        [_popUpWindow setOnBottomViewDidClick:^{
            [weakSelf removePopUpWindow];
        }];
    }
    return _popUpWindow;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    Wallet *model = CURRENT_WALLET;
    self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@的钱包", model.wallet_name];
    [self.headerView.avatarImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.wallet_img)) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    [self buidDataSource];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"";
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 34, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-34-TABBAR_HEIGHT);
    
    [self.mainTableView.mj_footer resetNoMoreData];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
    // 添加跑马灯
    CQMarqueeView *marqueeView = [[CQMarqueeView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 34)];
    
    [self.view addSubview:marqueeView];
    marqueeView.marqueeTextArray = @[@"温馨提示：本钱包运行于测试网络，待EOS主网正式上线后，您需要销毁本地钱包并使用您的手机号重新登录。届时我们将第一时间通知您并帮助您完成相关操作。"];
    marqueeView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        [self.mainTableView setTableHeaderView:self.headerView];
        self.navView.titleImg.hidden = NO;
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [self.mainTableView setTableHeaderView:self.BB_headerView];
        self.navView.titleImg.hidden = YES;
        
        [self.navView addSubview:self.currentAssestsLabel];
        self.currentAssestsLabel.sd_layout.centerXEqualToView(self.navView).bottomSpaceToView(self.navView, 10).heightIs(21);
        [self.currentAssestsLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-200];
        
        
        [self.navView addSubview:self.arrowImg];
        self.arrowImg.sd_layout.leftSpaceToView(self.currentAssestsLabel, 6).centerYEqualToView(_currentAssestsLabel).widthIs(8.7).heightIs(5);
        
    }
    
    [self.mainTableView.mj_header beginRefreshing];
    [self loadAllBlocks];
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    for (AccountInfo *model in accountArray) {
        if ([model.is_main_account isEqualToString:@"1"]) {
            AccountInfo *mainAccount = model;
            self.currentAccountName = mainAccount.account_name;
            self.currentAssestsLabel.text = self.currentAccountName;
        }
    }
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    
    
    
    
}

// 跑马灯view上的关闭按钮点击时回调
- (void)marqueeView:(CQMarqueeView *)marqueeView closeButtonDidClick:(UIButton *)sender {
    NSLog(@"点击了关闭按钮");
    [UIView animateWithDuration:1 animations:^{
        marqueeView.height = 0;
    } completion:^(BOOL finished) {
        [marqueeView removeFromSuperview];
    }];
}

// 构建数据源
- (void)buidDataSource{
    WS(weakSelf);
    self.mainService.getAccountAssetRequest.name = self.currentAccountName;
    [self.mainService get_account_asset:^(AccountResult *result, BOOL isSuccess) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.mainTableView.mj_header endRefreshing];
        if (isSuccess) {
            if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
                weakSelf.headerView.model = result.data;
            }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
                weakSelf.BB_headerView.model = result.data;
            }
            
            [weakSelf.mainTableView reloadData];
        }
    }];
}

- (void)loadAllBlocks{
    WS(weakSelf);
    // 默认的导航栏 block
    [self.navView setLeftBtnDidClickBlock:^{
        [weakSelf profileCenter];
    }];
   
    // 扫描二维码
    [self.navView setRightBtn1DidClickBlock:^{
    
        
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
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    }else {
                        // 用户第一次拒绝了访问相机权限
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                    
                    
                }];
            }else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"因为系统原因, 无法访问相册");
            }
            
            
        }else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        }
    }];
    
    // 改变后的导航栏 block
    [self.navView setChangedBtn1DidClickBlock:^{
        TransferViewController *vc = [[TransferViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navView setChangedBtn2DidClickBlock:^{
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navView setChangedBtn3DidClickBlock:^{
        RedPacketViewController *vc = [[RedPacketViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
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
        TransferViewController *vc = [[TransferViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setRecieveBtnDidClickBlock:^{
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setRedPacketBtnDidClickBlock:^{
        RedPacketViewController *vc = [[RedPacketViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setAccountQRCodeImgDidTapBlock:^{
        AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
        AccountInfo *model = [[AccountInfo alloc] init];
        model.account_name = weakSelf.currentAccountName;
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.headerView setAvatarImgDidTapBlock:^{
        PersonalSettingViewController *vc = [[PersonalSettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
 
    }];
    
    [self.BB_headerView setChangeAccountBtnDidClickBlock:^{
        
        ChangeAccountViewController *vc = [[ChangeAccountViewController alloc] init];
        NSMutableArray *accountInfoArray = [[AccountsTableManager accountTable] selectAccountTable];
        vc.dataArray = accountInfoArray;
        vc.changeAccountDataArrayType = ChangeAccountDataArrayTypeLocal;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.BB_headerView setTransferBtnDidClickBlock:^{
        TransferViewController *vc = [[TransferViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.BB_headerView setRecieveBtnDidClickBlock:^{
        RecieveViewController *vc = [[RecieveViewController alloc] init];
        vc.accountName = weakSelf.currentAccountName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssestsMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[AssestsMainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellIdentifier"];
        
    }
    Assests *model = self.mainService.dataSourceArray[indexPath.row];
    if ([model.assests_price_change_in_24 hasPrefix:@"-"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%%", model.assests_price_change_in_24]];
        [attrString addAttribute:NSForegroundColorAttributeName
                        value:HEXCOLOR(0xB51515)
                        range:NSMakeRange(0, model.assests_price_change_in_24.length +1)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }else{
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"+%@%%", model.assests_price_change_in_24]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x1E903C)
                           range:NSMakeRange(0, model.assests_price_change_in_24.length + 2)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }
    
    cell.model = model;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%f, %f", offset.x, offset.y);
    if (offset.y >= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y >= 300) {
        // 隐藏 headerview
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.originNavView.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.navView.changedNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        }];
    }else{
        // 显示 headerview
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.changedNavView.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
            self.navView.originNavView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssestsDetailViewController *vc = [[AssestsDetailViewController alloc] init];
    Assests *model = self.mainService.dataSourceArray[indexPath.row];
    vc.model = model;
    vc.accountName = self.currentAccountName;
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
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//    navi.navigationController.navigationBar.hidden = YES;
//    navi.navigationBar.hidden = YES;
    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
    
    
}

//ChangeAccountViewControllerDelegate
-(void)changeAccountCellDidClick:(NSString *)name{
    self.currentAccountName = name;
    [self buidDataSource];
}

- (void)loadNewData
{
    
    [self buidDataSource];
}


- (void)tapCurrentAssestsLabel:(UITapGestureRecognizer *)sender{
    [self.view addSubview:self.popUpWindow];
  
    self.popUpWindow.type = PopUpWindowTypeAccount;
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    if (IsStrEmpty(self.currentAccountName) && accountArray.count > 0) {
        AccountInfo *model = accountArray[0];
        model.selected = YES;
    }else{
        for (AccountInfo *model in accountArray) {
            if ([model.account_name isEqualToString:self.currentAccountName]) {
                model.selected = YES;
            }else{
                model.selected = NO;
            }
        }
    }
    [self.popUpWindow updateViewWithArray:accountArray title:@""];
}

// PopUpWindowDelegate
- (void)popUpWindowdidSelectItem:(id )sender{
    AccountInfo *accountInfo = sender;
    self.currentAccountName = accountInfo.account_name;
    self.currentAssestsLabel.text = self.currentAccountName;
    [self removePopUpWindow];
}

- (void)removePopUpWindow{
    [self.popUpWindow removeFromSuperview];
    self.popUpWindow = nil;
}


@end
