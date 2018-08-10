//
//  AccountQRCodeManagementViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AccountQRCodeManagementViewController.h"
#import "AccountQRCodeManagementHeaderView.h"
#import "SocialSharePanelView.h"
#import "SocialShareModel.h"

@interface AccountQRCodeManagementViewController ()<AccountQRCodeManagementHeaderViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) AccountQRCodeManagementHeaderView *headerView;
@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@end

@implementation AccountQRCodeManagementViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"账号二维码", nil) rightBtnImgName:@"share" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
        if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
            _navView.rightBtn.hidden = YES;
        }
    }
    return _navView;
}
- (AccountQRCodeManagementHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AccountQRCodeManagementHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 465);
    }
    return _headerView;
}

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.backgroundColor = HEXCOLOR(0xF7F7F7);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"朋友圈", nil)];//, NSLocalizedString(@"QQ好友", nil), NSLocalizedString(@"QQ空间", nil)
        for (int i = 0; i < titleArr.count; i++) {
            SocialShareModel *model = [[SocialShareModel alloc] init];
            model.platformName = titleArr[i];
            model.platformImage = self.platformNameArr[i];
            [modelArr addObject:model];
        }
        self.socialSharePanelView.imageTopSpace = 15;
        [_socialSharePanelView updateViewWithArray:modelArr];
    }
    return _socialSharePanelView;
}

- (NSArray *)platformNameArr{
    if (!_platformNameArr) {
        _platformNameArr = @[@"wechat_friends",@"wechat_moments", @"qq_friends", @"qq_Zone"];
    }
    return _platformNameArr;
}

- (UIView *)shareBaseView{
    if (!_shareBaseView) {
        _shareBaseView = [[UIView alloc] init];
        _shareBaseView.userInteractionEnabled = YES;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor blackColor];
        topView.alpha = 0.5;
        topView.userInteractionEnabled = YES;
        [_shareBaseView addSubview:topView];
        topView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).topSpaceToView(_shareBaseView, 0).heightIs(SCREEN_HEIGHT - 47 - 100 - 50);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [topView addGestureRecognizer:tap];
        
        UIButton *cancleBtn = [[UIButton alloc] init];
        [cancleBtn setTitle:NSLocalizedString(@"取消", nil)forState:(UIControlStateNormal)];
        [cancleBtn setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [cancleBtn setTitleColor:HEXCOLOR(0x2A2A2A) forState:(UIControlStateNormal)];
        [cancleBtn addTarget:self action:@selector(cancleShareAccountDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareBaseView addSubview:cancleBtn];
        cancleBtn.sd_layout.leftSpaceToView(_shareBaseView ,0 ).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_shareBaseView, 0).heightIs(47);
        
        [_shareBaseView addSubview:self.socialSharePanelView];
        _socialSharePanelView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(cancleBtn, 0).heightIs(100);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"    将二维码分享到", nil);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEXCOLOR(0x2A2A2A);
        [label setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [_shareBaseView addSubview: label];
        label.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_socialSharePanelView, 0).heightIs(50);
    }
    return _shareBaseView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    self.headerView.accountNameLabel.text = VALIDATE_STRING(self.model.account_name);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VALIDATE_STRING(self.model.account_name)  forKey:@"account_name"];
    [dic setObject:VALIDATE_STRING(self.model.account_img)  forKey:@"account_img"];
    [dic setObject: @"account_QRCode" forKey:@"type"];
    //帐号二维码
    NSString *QRCodeJsonStr = [dic mj_JSONString];
    self.headerView.QRCodeImg.image  = [SGQRCodeGenerateManager generateWithLogoQRCodeData:QRCodeJsonStr logoImageName:@"account_default_blue" logoScaleToSuperView:0.2];
}

//AccountQRCodeManagementHeaderViewDelegate
- (void)copyNameBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =VALIDATE_STRING(self.model.account_name);
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}


// NavigationViewDelegate
- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnDidClick{
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
}

// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    NSLog(@"%@", platformName);
    
    if ([platformName isEqualToString:@"wechat_friends"]) {
        [[SocialManager socialManager] wechatShareImageToScene:0 withImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        [[SocialManager socialManager] wechatShareImageToScene:1 withImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [[SocialManager socialManager] qqShareToScene:0 withShareImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [[SocialManager socialManager] qqShareToScene:1 withShareImage:[UIImage convertViewToImage:self.headerView.QRCodeImg]];
    }
}

- (void)cancleShareAccountDetail{
    [self.shareBaseView removeFromSuperview];
}

- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}

@end
