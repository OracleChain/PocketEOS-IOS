//
//  BindSocialPlatformViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BindSocialPlatformViewController.h"
#import "SocialManager.h"
#import "SocialModel.h"
#import "BindWechatRequest.h"
#import "BindQQRequest.h"
#import "NavigationView.h"
#import "BindSocialPlatformHeaderView.h"


@interface BindSocialPlatformViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, BindSocialPlatformHeaderViewDelegate>
@property(nonatomic , strong) BindWechatRequest *bindWechatRequest;
@property(nonatomic , strong) BindQQRequest *bindQQRequest;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) BindSocialPlatformHeaderView *headerView;

@end

@implementation BindSocialPlatformViewController

- (BindWechatRequest *)bindWechatRequest{
    if (!_bindWechatRequest) {
        _bindWechatRequest = [[BindWechatRequest alloc] init];
    }
    return _bindWechatRequest;
}
- (BindQQRequest *)bindQQRequest{
    if (!_bindQQRequest) {
        _bindQQRequest = [[BindQQRequest alloc] init];
    }
    return _bindQQRequest;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:[self.socialPlatformType isEqualToString:@"wechat"] ? @"绑定微信" : @"绑定QQ" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (BindSocialPlatformHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BindSocialPlatformHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 320);
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    
    if ([self.socialPlatformType isEqualToString:@"wechat"]) {
        self.headerView.platformImgView.image = [UIImage imageNamed:@"wechat_big"];
        self.headerView.tipLabel.text = @"您还没有绑定微信号";
        self.headerView.subtipLabel.text = @"绑定微信号可以关联您的XX资产";
        [self.headerView.bindBtn setTitle:@"绑定微信号" forState:(UIControlStateNormal)];
    }else if ([self.socialPlatformType isEqualToString:@"qq"]){
        self.headerView.platformImgView.image = [UIImage imageNamed:@"qq_big"];
        self.headerView.tipLabel.text = @"您还没有绑定QQ号";
        self.headerView.subtipLabel.text = @"绑定QQ号可以关联您的XX资产";
        [self.headerView.bindBtn setTitle:@"绑定QQ号" forState:(UIControlStateNormal)];
    }
    
}

// BindSocialPlatformHeaderViewDelegate
- (void)bindBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    [SVProgressHUD show];
    if ([self.socialPlatformType isEqualToString:@"wechat"]) {
        [[SocialManager socialManager] wechatLoginRequest];
        [[SocialManager socialManager] setOnWechatLoginSuccess:^(SocialModel *model) {
            weakSelf.bindWechatRequest.uid = CURRENT_WALLET_UID;
            weakSelf.bindWechatRequest.name = model.name;
            weakSelf.bindWechatRequest.avatar = model.avatar;
            weakSelf.bindWechatRequest.openid = model.openid;
            [weakSelf.bindWechatRequest postDataSuccess:^(id DAO, id data) {
                NSNumber *code = data[@"code"];
                if ([code isEqualToNumber:@0]) {
                    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_weixin = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , model.openid , CURRENT_WALLET_UID]];
                }
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failure:^(id DAO, NSError *error) {
                NSLog(@"%@", error);
            }];
        }];
        
    }else if ([self.socialPlatformType isEqualToString:@"qq"]){
        
        [[SocialManager socialManager] qqLoginRequest];
        [[SocialManager socialManager] setOnQQLoginSuccess:^(SocialModel *model) {
            weakSelf.bindQQRequest.uid = CURRENT_WALLET_UID;
            weakSelf.bindQQRequest.name = model.name;
            weakSelf.bindQQRequest.avatar = model.avatar;
            weakSelf.bindQQRequest.openid = model.openid;
            [weakSelf.bindQQRequest postDataSuccess:^(id DAO, id data) {
                NSNumber *code = data[@"code"];
                if ([code isEqualToNumber:@0]) {
                    [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_qq = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , model.name , CURRENT_WALLET_UID]];
                }
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failure:^(id DAO, NSError *error) {
                NSLog(@"%@", error);
            }];
        }];
    }
}

// NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
