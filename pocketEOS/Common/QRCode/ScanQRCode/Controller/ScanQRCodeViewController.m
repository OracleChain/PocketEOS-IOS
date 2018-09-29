
//
//  ScanQRCodeViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "ScanQRCodeSuccessViewController.h"
#import "NavigationView.h"
#import "SGQRCode.h"
#import <AVFoundation/AVFoundation.h>
#import "RichlistDetailViewController.h"
#import "Follow.h"
#import "AccountPrivateKeyQRCodeModel.h"
#import "ImportAccountViewController.h"
#import "TransferNewViewController.h"
#import "TransferModel.h"
#import "Get_token_info_service.h"
#import "RecieveTokenModel.h"
#import "ExcuteActionsViewController.h"
#import "SGQRCodeScanView.h"
#import "SimpleWalletLoginModel.h"
#import "SimpleWalletTransferModel.h"
#import "SimpleWalletLoginViewController.h"
#import "SimpleWalletTransferViewController.h"


static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;
@interface ScanQRCodeViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

{
    SGQRCodeObtain *obtain;
}

@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;

@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) Get_token_info_service *get_token_info_service;

@end

@implementation ScanQRCodeViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"扫一扫", nil)rightBtnTitleName:NSLocalizedString(@"相册", nil)delegate:self];
        _navView.leftBtn
        .lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal)
        .LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}


- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (NSMutableArray *)get_token_info_service_data_array{
    if (!_get_token_info_service_data_array) {
        _get_token_info_service_data_array = [[NSMutableArray alloc] init];
    }
    return _get_token_info_service_data_array;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"扫一扫"]; //("Pagename"为页面名称，可自定义)
    if (_stop) {
        [obtain startRunningWithBefore:^{
            // 在此可添加 HUD
        } completion:^{
            // 在此可移除 HUD
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"扫一扫"];
    [self.scanView removeTimer];
}

- (void)dealloc {
    NSLog(@"WBQRCodeVC - dealloc");
    [self removeScanningView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    
    [self.view addSubview:self.navView];
}


- (void)scanQRCodeResultHandler:(NSString *)scannedResult{
    NSMutableDictionary *scannedResultdict =  scannedResult.mj_JSONObject;
    
    if ([scannedResult containsString:@"wallet_QRCode"] ) {
        // 钱包二维码
        RichlistDetailViewController *vc = [[RichlistDetailViewController alloc] init];
        Follow *model = [[Follow alloc] init];
        model.followType = @1;
        model.uid = [scannedResultdict objectForKey:@"wallet_uid"];
        model.displayName = [scannedResultdict objectForKey:@"wallet_name"];
        model.avatar = [scannedResultdict objectForKey:@"wallet_img"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"account_QRCode"]){
        // 帐号二维码
        RichlistDetailViewController *vc = [[RichlistDetailViewController alloc] init];
        Follow *model = [[Follow alloc] init];
        model.followType = @2;
        model.displayName = [scannedResultdict objectForKey:@"account_name"];
        model.avatar = [scannedResultdict objectForKey:@"account_img"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"account_priviate_key_QRCode"]){
        // 账号私钥二维码
        AccountPrivateKeyQRCodeModel *model = [AccountPrivateKeyQRCodeModel mj_objectWithKeyValues: [scannedResult mj_JSONObject]];
        ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"make_collections_QRCode"] && ![scannedResult containsString:@"contract"]){
        TransferModel *model = [TransferModel mj_objectWithKeyValues: [scannedResult mj_JSONObject]];
        TransferNewViewController *vc = [[TransferNewViewController alloc] init];
        vc.transferModel = model;
        vc.get_token_info_service_data_array = self.get_token_info_service_data_array;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"token_make_collections_QRCode"] && [scannedResult containsString:@"contract"]){
        RecieveTokenModel *model = [RecieveTokenModel mj_objectWithKeyValues: [scannedResult mj_JSONObject]];
        TransferNewViewController *vc = [[TransferNewViewController alloc] init];
        vc.recieveTokenModel = model;
        vc.get_token_info_service_data_array = self.get_token_info_service_data_array;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"actions_QRCode"]){
        // excute actions
        ExcuteActionsViewController *vc = [[ExcuteActionsViewController alloc] init];
        vc.actionsResultDict = scannedResult;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([scannedResult containsString:@"SimpleWallet"]){
        // "protocol": "SimpleWallet"
        if ([scannedResult containsString: @"login"]) {
            SimpleWalletLoginViewController *vc = [[SimpleWalletLoginViewController alloc] init];
            vc.scannedResult = scannedResult;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([scannedResult containsString: @"transfer"]){
            SimpleWalletTransferViewController *vc = [[SimpleWalletTransferViewController alloc] init];
            vc.scannedResult = scannedResult;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
    }
    
    
    
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"scannedResult" message: VALIDATE_STRING(scannedResult) delegate:self cancelButtonTitle:@"cancle" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
    }
}

//UIAlertViewDelegate
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [obtain startRunningWithBefore:^{
        //        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
    } completion:^{
        //        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
    }];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        //        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
    } completion:^{
        //        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
            [obtain stopRunning];
            weakSelf.stop = YES;
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            [weakSelf scanQRCodeResultHandler:result];
        }
    }];
}



-(void)leftBtnDidClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    __weak typeof(self) weakSelf = self;
    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
        } else {
            [weakSelf scanQRCodeResultHandler:result];
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        // 静态库加载 bundle 里面的资源使用 SGQRCode.bundle/QRCodeScanLineGrid
        // 动态库加载直接使用 QRCodeScanLineGrid
        _scanView.scanImageName = @"SGQRCode.bundle/QRCodeScanLine";
        _scanView.scanAnimationStyle = ScanAnimationStyleDefault;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = HEXCOLOR(0x40BD30);
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

@end
