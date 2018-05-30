//
//  GenerateQRCodeViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GenerateQRCodeViewController.h"
#import "SGQRCode.h"
#import "NavigationView.h"

@interface GenerateQRCodeViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation GenerateQRCodeViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"钱包的二维码" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.87 alpha:1.0];
    [self.view addSubview:self.navView];
    
    // 生成二维码(Default)
    [self setupGenerateQRCode];
    
}

// 生成二维码
- (void)setupGenerateQRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 80;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    Wallet *wallet = CURRENT_WALLET;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject: VALIDATE_STRING(wallet.wallet_name)  forKey:@"wallet_name"];
    [dic setObject: VALIDATE_STRING(wallet.wallet_uid)  forKey:@"wallet_uid"];
    [dic setObject: VALIDATE_STRING(wallet.wallet_img)  forKey:@"wallet_img"];
    [dic setObject:@"wallet_QRCode" forKey:@"type"];
    NSString *QRCodeJsonStr = [dic mj_JSONString];
    
    // 2、将CIImage转换成UIImage，并放大显示
    imageView.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:QRCodeJsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
    
    
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
