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
#import "ShareModel.h"
#import "ForwardRedPacketService.h"
#import "AuthRedPacketResult.h"
#import "AuthRedPacket.h"
#import "ForwardRedPacketFooterView.h"

@interface ForwardRedPacketViewController ()
<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, ForwardRedPacketHeaderViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ForwardRedPacketHeaderView *headerView;
@property(nonatomic , strong) ForwardRedPacketFooterView *footerView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@property(nonatomic , strong) ForwardRedPacketService *mainService;
@property(nonatomic , strong) AuthRedPacketResult *authRedPacketResult;
@end

@implementation ForwardRedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"红包已封口!", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = RGB(214, 62, 67);
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
- (ForwardRedPacketFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"ForwardRedPacketFooterView" owner:nil options:nil] firstObject];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT-80 , SCREEN_WIDTH, 80);
    }
    return _footerView;
}

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT+266, SCREEN_WIDTH, 116);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"朋友圈", nil)];//, NSLocalizedString(@"QQ好友", nil), NSLocalizedString(@"QQ空间", nil)
        for (int i = 0; i < titleArr.count; i++) {
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
- (ForwardRedPacketService *)mainService{
    if (!_mainService) {
        _mainService = [[ForwardRedPacketService alloc] init];
    }
    return _mainService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
    self.headerView.accountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@，%@%@%@", nil), self.redPacketModel.count, NSLocalizedString(@"个红包", nil),NSLocalizedString(@"共", nil), self.redPacketModel.amount, self.redPacketModel.coin];
    self.headerView.descriptionLabel.text = self.redPacketModel.memo.length > 0 ? self.redPacketModel.memo : NSLocalizedString(@"", nil);//恭喜发财，大吉大利
    self.footerView.accountLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"", nil), self.redPacketModel.from];
    [self.view addSubview:self.socialSharePanelView];
    
    self.mainService.auth_redpacket_request.redPacket_id = self.redPacketModel.redPacket_id;
    self.mainService.auth_redpacket_request.transactionId = self.redPacketModel.transactionId;
    WS(weakSelf);
    [self.mainService authRedpacket:^(AuthRedPacketResult *result, BOOL isSuccess) {
        weakSelf.authRedPacketResult = result;
        weakSelf.footerView.backupTimeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"返回时间", nil),  weakSelf.authRedPacketResult.data.endTime];
        
    }];
}

- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    if ([self.authRedPacketResult.code isEqualToNumber:@0]) {
        self.footerView.backupTimeLabel.text = [NSString stringWithFormat:@"返回时间:%@",  self.authRedPacketResult.data.endTime];
        NSString *platformName = self.platformNameArr[sender.view.tag-1000];
        NSLog(@"%@", platformName);
        ShareModel *model = [[ShareModel alloc] init];
        model.title = NSLocalizedString(@"天降大红包，没时间解释了，快抢!", nil);
        model.imageName = @"https://pocketeos.oss-cn-beijing.aliyuncs.com/redpacket.png";
        model.detailDescription = NSLocalizedString(@"我下血本送上的区块链红包，无需消费、可以兑现，还犹豫什么？手慢无哦！", nil);
        // http://static.pocketeos.top:8003
        model.webPageUrl = [NSString stringWithFormat:@"http://static.pocketeos.top:8003?id=%@&verifystring=%@",self.redPacketModel.redPacket_id,self.authRedPacketResult.data.verifyString];
        NSLog(@"model.webPageUrl :%@", model.webPageUrl);
        if ([platformName isEqualToString:@"wechat_friends"]) {
            [[SocialManager socialManager] wechatShareToScene:0 withShareModel:model];
        }else if ([platformName isEqualToString:@"wechat_moments"]){
            [[SocialManager socialManager] wechatShareToScene:1 withShareModel:model];
        }else if ([platformName isEqualToString:@"qq_friends"]){
            [TOASTVIEW showWithText:@"暂不支持~"];
        }else if ([platformName isEqualToString:@"qq_Zone"]){
            [TOASTVIEW showWithText:@"暂不支持~"];
        }
        
    }else{
        [TOASTVIEW showWithText:self.authRedPacketResult.message];
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
