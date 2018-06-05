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
#import "TransferViewController.h"
#import "TransferModel.h"


static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;
@interface ScanQRCodeViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation ScanQRCodeViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"扫一扫" rightBtnTitleName:@"相册" delegate:self];
        _navView.leftBtn
        .lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal)
        .LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
        //        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        //        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        //        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //这个属性必须打开否则返回的时候会出现黑边
    self.view.clipsToBounds=YES;

    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.navView];
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
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
    }else if ([scannedResult containsString:@"make_collections_QRCode"]){
        TransferModel *model = [TransferModel mj_objectWithKeyValues: [scannedResult mj_JSONObject]];
        TransferViewController *vc = [[TransferViewController alloc] init];
        vc.transferModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"scannedResult" message: VALIDATE_STRING(scannedResult) delegate:self cancelButtonTitle:@"cancle" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark-> 我的相册
-(void)myAlbum{
    
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
    
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    //    [manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}


#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}

- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    [self scanQRCodeResultHandler:VALIDATE_STRING(result)];
}
/// 图片选择控制器读取图片二维码信息失败的回调函数
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager{
    NSLog(@"图片选择控制器读取图片二维码信息失败的回调函数");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
//        [scanManager palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *scannedResult = [obj stringValue];
        [self scanQRCodeResultHandler:VALIDATE_STRING(scannedResult)];
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

-(void)leftBtnDidClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)rightBtnDidClick{
    [self myAlbum];
}

@end
