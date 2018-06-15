//
//  ForwardRedPacketViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ForwardRedPacketViewController.h"
#import "ForwardRedPacketHeaderView.h"
#import "NavigationView.h"
#import "SocialSharePanelView.h"
#import "SocialShareModel.h"

@interface ForwardRedPacketViewController ()
<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, ForwardRedPacketHeaderViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ForwardRedPacketHeaderView *headerView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@end

@implementation ForwardRedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"红包已封口!", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = RGB(225, 85, 76);
        _navView.titleLabel.textColor = [UIColor whiteColor];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal);
    }
    return _navView;
}

- (ForwardRedPacketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ForwardRedPacketHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT , SCREEN_WIDTH, 266);
    }
    return _headerView;
}

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT+266, SCREEN_WIDTH, 116);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"朋友圈", nil), NSLocalizedString(@"QQ好友", nil), NSLocalizedString(@"QQ空间", nil)];
        for (int i = 0; i < 4; i++) {
            SocialShareModel *model = [[SocialShareModel alloc] init];
            model.platformName = titleArr[i];
            model.platformImage = self.platformNameArr[i];
            [modelArr addObject:model];
        }
        self.socialSharePanelView.labelTopSpace = 33;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.headerView.accountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@个红包，共%@%@", nil), self.redPacketModel.count, self.redPacketModel.amount, self.redPacketModel.coin];
    self.headerView.descriptionLabel.text = self.redPacketModel.memo.length > 0 ? self.redPacketModel.memo : NSLocalizedString(@"恭喜发财，大吉大利", nil);
    [self.view addSubview:self.socialSharePanelView];
}

- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    NSLog(@"%@", platformName);
    
    if ([platformName isEqualToString:@"wechat_friends"]) {
        
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        
    }else if ([platformName isEqualToString:@"qq_friends"]){
        
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        
    }
}



- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)continueSendRedPacketBtnDidClick:(UIButton *)sender{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"继续发送红包", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
