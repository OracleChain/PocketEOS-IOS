//
//  PersonalSettingViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "PersonnalSettingDetailViewController.h"
#import "BindSocialPlatformViewController.h"
#import "UnBindSocialPlatformViewController.h"
#import "SliderVerifyView.h"
#import "LoginPasswordView.h"
#import "LoginMainViewController.h"
#import "AppDelegate.h"
#import "PersonalSettingService.h"
#import "RSKImageCropper.h"
#import "PersonalSettingHeaderView.h"
#import "NavigationView.h"

@interface PersonalSettingViewController ()<UIGestureRecognizerDelegate ,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SliderVerifyViewDelegate, LoginPasswordViewDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, NavigationViewDelegate , PersonalSettingHeaderViewDelegate>
@property(nonatomic, strong) SliderVerifyView *sliderVerifyView;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) PersonalSettingService *mainService;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PersonalSettingHeaderView *headerView;

@end

@implementation PersonalSettingViewController

- (SliderVerifyView *)sliderVerifyView{
    if (!_sliderVerifyView) {
        _sliderVerifyView = [[SliderVerifyView alloc] init];
        _sliderVerifyView.tipLabel.text = @"滑动销毁钱包";
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

- (PersonalSettingService *)mainService{
    if (!_mainService) {
        _mainService = [[PersonalSettingService alloc] init];
    }
    return _mainService;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"个人设置" rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (PersonalSettingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"PersonalSettingHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 250);
    }
    return _headerView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    Wallet *model = CURRENT_WALLET;
    if (IsStrEmpty(model.wallet_name)) {
        self.headerView.userNameLabel.text = [NSString stringWithFormat:@"******的钱包"];
    }else{
        self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@的钱包", model.wallet_name];
        
    }
    [self.headerView.avatarImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.wallet_img)) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    
    if (model.wallet_weixin.length > 0 &&  ![model.wallet_weixin isEqualToString:@"(null)"]) {
        self.headerView.wechatIDLabel.text = model.wallet_weixin;
    }else{
        self.headerView.wechatIDLabel.text = @"未绑定微信";
    }
    if (model.wallet_qq.length > 0 &&  ![model.wallet_qq isEqualToString:@"(null)"]) {
        self.headerView.qqIDLabel.text = model.wallet_qq;
    }else{
        self.headerView.qqIDLabel.text = @"未绑定QQ";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.sliderVerifyView];
    self.view.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.sliderVerifyView.sd_layout.leftSpaceToView(self.view, MARGIN_20).rightSpaceToView(self.view, MARGIN_20).topSpaceToView(self.headerView, 20).heightIs(48);
        [self.view addSubview:self.tipLabel];
        self.tipLabel.sd_layout.leftSpaceToView(self.view, 20).rightSpaceToView(self.view, 20).topSpaceToView(self.sliderVerifyView, 10).heightIs(18);
      
        
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.headerView.avatarBaseView.hidden = YES;
        self.headerView.wechatBaseView.hidden = YES;
        self.headerView.qqBaseView.hidden = YES;
        self.headerView.line2.hidden = YES;
        self.headerView.line3.hidden = YES;
        self.headerView.line4.hidden = YES;
        self.headerView.line5.hidden = YES;
        self.headerView.nameBaseView.sd_layout.topSpaceToView(self, 0);
        self.sliderVerifyView.sd_layout.leftSpaceToView(self.view, 48).rightSpaceToView(self.view, 48).topSpaceToView(self.headerView.nameBaseView, 20).heightIs(48);
        [self.view addSubview:self.tipLabel];
        self.tipLabel.sd_layout.leftSpaceToView(self.view, 20).rightSpaceToView(self.view, 20).topSpaceToView(self.sliderVerifyView, 10).heightIs(18);
        

        
    }
    
}

//PersonalSettingHeaderViewDelegate
-(void)avatarBtnDidClick:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"我的相册", @"拍照", nil];
    [sheet dismissWithClickedButtonIndex:2 animated:YES];
    [sheet showInView:self.view];
    
}

-(void)nameBtnDidClick:(UIButton *)sender{
    PersonnalSettingDetailViewController *vc = [[PersonnalSettingDetailViewController alloc] init];
    vc.titleStr = @"名字";
    vc.itemName = @"名字";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)wechatIDBtnDidClick:(UIButton *)sender{
    Wallet *wallet = CURRENT_WALLET;
    if (wallet.wallet_weixin.length > 0 &&  ![wallet.wallet_weixin isEqualToString:@"(null)"]) {
        UnBindSocialPlatformViewController *vc = [[UnBindSocialPlatformViewController alloc] init];
        vc.socialPlatformType = @"wechat";
        vc.socialPlatformName = wallet.wallet_weixin;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        BindSocialPlatformViewController *vc = [[BindSocialPlatformViewController alloc] init];
        vc.socialPlatformType = @"wechat";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)qqIDBtnBtnDidClick:(UIButton *)sender{
    Wallet *wallet = CURRENT_WALLET;
    if (wallet.wallet_qq.length > 0 &&  ![wallet.wallet_qq isEqualToString:@"(null)"]) {
        UnBindSocialPlatformViewController *vc = [[UnBindSocialPlatformViewController alloc] init];
        vc.socialPlatformType = @"qq";
        vc.socialPlatformName = wallet.wallet_qq;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BindSocialPlatformViewController *vc = [[BindSocialPlatformViewController alloc] init];
        vc.socialPlatformType = @"qq";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 相册
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
            [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }else if (buttonIndex == 1){
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            [self presentImagePickerWithSourceType:(UIImagePickerControllerSourceTypeCamera)];
        }
    }else if (buttonIndex == 2 ){
        // 取消
    }
}

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = sourceType;
//    controller.allowsEditing=YES;//允许编辑
    controller.delegate = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    imageCropVC.dataSource=self;
    //注意 如果想使用dataSource来自定义裁剪框的形状和图片裁剪的尺寸，则这里一定要设置为RSKImageCropModeCustom 否则在dataSource协议中实现的方法会无效
    imageCropVC.cropMode=RSKImageCropModeCircle;
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

// RSKImageCropViewControllerDelegate
/**
 Tells the delegate that crop image has been canceled.
 */
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
     [self.navigationController popViewControllerAnimated:YES];
}

/**
 Tells the delegate that the original image has been cropped. Additionally provides a crop rect and a rotation angle used to produce image.
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle{
    self.headerView.avatarImg.image = croppedImage;
    
    NSData *imageData = UIImageJPEGRepresentation([self image:croppedImage byScalingToSize:CGSizeMake(200, 200)], 0.2f);
    [self.mainService.uploadWalletAvatarImageRequest uploadData:imageData externName:nil success:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@", data);
            [TOASTVIEW showWithText: VALIDATE_STRING(data[@"message" ]) ];
            [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_img = '%@' WHERE wallet_uid = '%@'",  WALLET_TABLE, data[@"data"], CURRENT_WALLET_UID]];
            [self.headerView.avatarImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(data[@"data"])) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
        }
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", DAO);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

//更改图片大小
- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)pushViewController:(NSString *)type{
    
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

// SliderVerifyViewDelegate
-(void)sliderVerifyDidSuccess{
    [self.view addSubview:self.loginPasswordView];
}

// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}
-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:@"密码输入错误!"];
        return;
    }
    
    [[WalletTableManager walletTable] deleteRecord:CURRENT_WALLET_UID];
    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"DROP TABLE '%@'" , current_wallet.account_info_table_name]];

    for (UIView *view in WINDOW.subviews) {
        [view removeFromSuperview];
        
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginMainViewController alloc] init]];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: navi];
    
}



@end
