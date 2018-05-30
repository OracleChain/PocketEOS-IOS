//
//  UnBindSocialPlatformViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "UnBindSocialPlatformViewController.h"
#import "UnbindWechatRequest.h"
#import "UnbindQQRequest.h"
#import "NavigationView.h"
#import "UnBindSocialPlatformHeaderView.h"


@interface UnBindSocialPlatformViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, UnBindSocialPlatformHeaderViewDelegate>

@property(nonatomic , strong) UnbindWechatRequest *unbindWechatRequest;
@property(nonatomic , strong) UnbindQQRequest *unbindQQRequest;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) UnBindSocialPlatformHeaderView *headerView;
@end

@implementation UnBindSocialPlatformViewController

- (UnbindWechatRequest *)unbindWechatRequest{
    if (!_unbindWechatRequest) {
        _unbindWechatRequest = [[UnbindWechatRequest alloc] init];
    }
    return _unbindWechatRequest;
}
- (UnbindQQRequest *)unbindQQRequest{
    if (!_unbindQQRequest) {
        _unbindQQRequest = [[UnbindQQRequest alloc] init];
    }
    return _unbindQQRequest;
}
- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:[self.socialPlatformType isEqualToString:@"wechat"] ? @"解绑微信" : @"解绑QQ" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (UnBindSocialPlatformHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UnBindSocialPlatformHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 320);
    }
    return _headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    
    if ([self.socialPlatformType isEqualToString:@"wechat"]) {
        self.headerView.platformImg.image = [UIImage imageNamed:@"wechat_big"];
        self.headerView.tipLabel.text = [NSString stringWithFormat:@"绑定微信号%@", self.socialPlatformName];
    }else if ([self.socialPlatformType isEqualToString:@"qq"]){
        self.headerView.platformImg.image = [UIImage imageNamed:@"qq_big"];
        self.headerView.tipLabel.text = [NSString stringWithFormat:@"绑定QQ号%@", self.socialPlatformName];
        
    }
}



// unBindSocialPlatformHeaderViewDelegate
-(void)unBindBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    if ([self.socialPlatformType isEqualToString:@"wechat"]) {
        self.unbindWechatRequest.uid = CURRENT_WALLET_UID;
        [self.unbindWechatRequest postDataSuccess:^(id DAO, id data) {
            NSNumber *code = data[@"code"];
            if ([code isEqualToNumber:@0]) {
                [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_weixin = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE ,@"(null)" , CURRENT_WALLET_UID]];
            }
            [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }else if ([self.socialPlatformType isEqualToString:@"qq"]){
        
        self.unbindQQRequest.uid = CURRENT_WALLET_UID;
        [self.unbindQQRequest postDataSuccess:^(id DAO, id data) {
            NSNumber *code = data[@"code"];
            if ([code isEqualToNumber:@0]) {
                [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_qq = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , @"(null)" , CURRENT_WALLET_UID]];
            }
            [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

//NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
