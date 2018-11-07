//
//  ShareToFrirndsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ShareToFrirndsViewController.h"
#import "SocialSharePanelView.h"
#import "SocialShareModel.h"
#import "SocialModel.h"


@interface ShareToFrirndsViewController ()<SocialSharePanelViewDelegate>
@property(nonatomic, strong) NavigationView *navView;

@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@end

@implementation ShareToFrirndsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"分享给好友", nil)rightBtnTitleName:NSLocalizedString(@"分享", nil) delegate:self];
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _navView.rightBtn.hidden = NO;
        }else{
            _navView.rightBtn.hidden = YES;
        }
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}



- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.backgroundColor = HEXCOLOR(0xF7F7F7);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"朋友圈", nil)];//NSLocalizedString(@"QQ好友", nil), NSLocalizedString(@"QQ空间", nil)
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
        _platformNameArr = @[@"wechat_friends",@"wechat_moments", @"qq_friends", @"qq_Zone"];//@"qq_friends", @"qq_Zone"
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
        topView.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).topSpaceToView(_shareBaseView, 0).heightIs(SCREEN_HEIGHT - 47 - 100 );
        
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
        
    }
    return _shareBaseView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"shareToFriendsImage.jpg"];
    img.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT);
    [self.view addSubview:img];
    
}

// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    NSLog(@"%@", platformName);
    
    UIImage *shareImg = [UIImage imageNamed:@"shareToFriendsImage.jpg"];
    
    if ([platformName isEqualToString:@"wechat_friends"]) {
        [[SocialManager socialManager] wechatShareImageToScene:0 withImage:shareImg];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        [[SocialManager socialManager] wechatShareImageToScene:1 withImage:shareImg];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [[SocialManager socialManager] qqShareToScene:0 withShareImage:shareImg];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [[SocialManager socialManager] qqShareToScene:1 withShareImage:shareImg];
    }
}


-(void)rightBtnDidClick{
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}

- (void)cancleShareAccountDetail{
    [self.shareBaseView removeFromSuperview];
}


@end
