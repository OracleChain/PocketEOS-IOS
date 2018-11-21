//
//  ImportAccountWithoutAccountNameBaseViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountWithoutAccountNameBaseViewController.h"
#import "ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController.h"
#import "ImportAccountWithoutAccountNameDoublePrivateKeyModeViewController.h"
#import "PageSegmentView.h"
#import "ScanQRCodeViewController.h"


@interface ImportAccountWithoutAccountNameBaseViewController ()<PageSegmentViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) PageSegmentView *segmentView;
@end

@implementation ImportAccountWithoutAccountNameBaseViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"导入账号", nil) rightBtnImgName:@"scan_black" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (PageSegmentView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[PageSegmentView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT)];
        self.segmentView.selectedLineWidth = 24;
        self.segmentView.tabViewWidth = SCREEN_WIDTH;
        self.segmentView.delegate = self;
        
    }
    return _segmentView;
}

-(NSMutableArray *)allVC{
    if (!_allVC) {
        _allVC = [NSMutableArray array];
    }
    return _allVC;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self configSegmentView];
}


- (void)configSegmentView{
    ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController *vc1 = [[ImportAccountWithoutAccountNameSinglePrivateKeyModeViewController alloc]init];
    vc1.title = NSLocalizedString(@"单私钥", nil);
    vc1.navigationController = self.navigationController;
    [vc1.navigationController.navigationBar setHidden: YES];
    [_allVC addObject:vc1];
    
    ImportAccountWithoutAccountNameDoublePrivateKeyModeViewController *vc2 = [[ImportAccountWithoutAccountNameDoublePrivateKeyModeViewController alloc]init];
    vc2.title = NSLocalizedString(@"双私钥", nil);
    vc2.navigationController = self.navigationController;
    [vc2.navigationController.navigationBar setHidden: YES];
    [_allVC addObject:vc2];
    _allVC = [NSMutableArray arrayWithObjects:vc1 , vc2, nil];
    self.segmentView.delegate = self;
    // 可自定义背景色和tab button的文字颜色等
    // _segmentView.selectedLineWidth = 50;
    // 开始构建UI
    [self.view addSubview:self.segmentView];
    [self.segmentView buildUI];
    self.segmentView.leftBtn.hidden = YES;
    self.segmentView.rightView.hidden = YES;
    [self.segmentView selectTabWithIndex:1 animate:NO];
    // 显示红点，点击消失
    //                [_segmentView showRedDotWithIndex:0];
    
    
}



#pragma mark - DBPagerTabView Delegate

- (NSUInteger)numberOfPagers:(PageSegmentView *)view {
    return [_allVC count];
}

- (UIViewController *)pagerViewOfPagers:(PageSegmentView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
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
@end
