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
#import "SocialShareModel.h"
#import "ShareModel.h"
#import "ForwardRedPacketService.h"
#import "AuthRedPacketResult.h"
#import "AuthRedPacket.h"
#import "ForwardRedPacketFooterView.h"
#import "RedPacketPrepareDetailView.h"
#import "RedPacketPrepareFailedDetailView.h"
#import "SocialSharePanelView.h"

@interface ForwardRedPacketViewController ()
<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, ForwardRedPacketHeaderViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ForwardRedPacketHeaderView *headerView;
@property(nonatomic , strong) RedPacketPrepareDetailView *redPacketPrepareDetailView;
@property(nonatomic , strong) RedPacketPrepareFailedDetailView *redPacketPrepareFailedDetailView;
@property(nonatomic , strong) ForwardRedPacketFooterView *footerView;
@property(nonatomic , strong) NSArray *platformNameArr;
@property(nonatomic , strong) ForwardRedPacketService *mainService;
@property(nonatomic , strong) AuthRedPacketResult *authRedPacketResult;
@property(nonatomic , strong) dispatch_source_t timer;

@property(nonatomic , assign) NSUInteger currentBlockNum;
@property(nonatomic , assign) NSUInteger mainNetBlockNum;

@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@end

@implementation ForwardRedPacketViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"发红包", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = RGB(214, 62, 67);
        _navView.titleLabel.textColor = [UIColor whiteColor];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal);
    }
    return _navView;
}

- (ForwardRedPacketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ForwardRedPacketHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT , SCREEN_WIDTH, 300);
        _headerView.delegate = self;
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

- (RedPacketPrepareDetailView *)redPacketPrepareDetailView{
    if (!_redPacketPrepareDetailView) {
        _redPacketPrepareDetailView = [[[NSBundle mainBundle] loadNibNamed:@"RedPacketPrepareDetailView" owner:nil options:nil] firstObject];
        _redPacketPrepareDetailView.frame = CGRectMake(MARGIN_20, NAVIGATIONBAR_HEIGHT + 300 , SCREEN_WIDTH-(MARGIN_20 *2), 220);
    }
    return _redPacketPrepareDetailView;
}

- (RedPacketPrepareFailedDetailView *)redPacketPrepareFailedDetailView{
    if (!_redPacketPrepareFailedDetailView) {
        _redPacketPrepareFailedDetailView = [[[NSBundle mainBundle] loadNibNamed:@"RedPacketPrepareFailedDetailView" owner:nil options:nil] firstObject];
        _redPacketPrepareFailedDetailView.frame = CGRectMake(MARGIN_20, NAVIGATIONBAR_HEIGHT + 300 , SCREEN_WIDTH-(MARGIN_20 *2), 85);
    }
    return _redPacketPrepareFailedDetailView;
}

- (ForwardRedPacketService *)mainService{
    if (!_mainService) {
        _mainService = [[ForwardRedPacketService alloc] init];
    }
    return _mainService;
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
        label.text = NSLocalizedString(@"    将红包发送到", nil);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEXCOLOR(0x2A2A2A);
        [label setBackgroundColor:HEXCOLOR(0xF7F7F7)];
        [_shareBaseView addSubview: label];
        label.sd_layout.leftSpaceToView(_shareBaseView, 0).rightSpaceToView(_shareBaseView, 0).bottomSpaceToView(_socialSharePanelView, 0).heightIs(50);
        
    }
    return _shareBaseView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self configHeaderView];
    [self requestRedpacketResult];
}

- (void)requestRedpacketResult{
    WS(weakSelf);
    self.mainService.auth_redpacket_request.redPacket_id = self.redPacketModel.redPacket_id;
    [self.mainService authRedpacket:^(AuthRedPacketResult *result, BOOL isSuccess) {
        weakSelf.authRedPacketResult = result;
        [weakSelf configRedPacketPrepareResultView];
        [weakSelf configHeaderViewConfirmBtn];
    }];
}

- (void)configHeaderView{
    self.headerView.accountLabel.text = self.redPacketModel.from;
    self.headerView.memoLabel.text = self.redPacketModel.memo;
    self.headerView.tipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@，%@%@%@", nil), self.redPacketModel.count, NSLocalizedString(@"个红包", nil),NSLocalizedString(@"共", nil), self.redPacketModel.amount, self.redPacketModel.coin];
}

- (void)configRedPacketPrepareResultView{
    
    if (self.authRedPacketResult.data.payStatus.integerValue == 4 || self.authRedPacketResult.data.payStatus.integerValue == 1 ) {// 4: 等待交易确认  1. 支付成功
        if (self.redPacketPrepareFailedDetailView) {
            self.redPacketPrepareFailedDetailView.hidden = YES;
        }
        [self.view addSubview:self.redPacketPrepareDetailView];
        self.redPacketPrepareDetailView.hidden = NO;
        self.redPacketPrepareDetailView.redpacket_id_label.text = self.authRedPacketResult.data.redpacket_id;
        self.redPacketPrepareDetailView.createTimeLabel.text = self.authRedPacketResult.data.createTime;
        self.redPacketPrepareDetailView.refundTimeLabel.text = self.authRedPacketResult.data.endTime;
        self.redPacketPrepareDetailView.tx_id_label.text = self.authRedPacketResult.data.transaction_id;
        self.redPacketPrepareDetailView.blockNumLabel.text = self.authRedPacketResult.data.blockNum.stringValue;
        self.redPacketPrepareDetailView.confirmProcessLabel.text = self.authRedPacketResult.data.sureBlockNum;
        [self confirmProgressAutoIncreass];
    }else {
        if (self.redPacketPrepareDetailView) {
            self.redPacketPrepareDetailView.hidden = YES;
        }
        [self.view addSubview:self.redPacketPrepareFailedDetailView];
        self.redPacketPrepareFailedDetailView.hidden = NO;
        self.redPacketPrepareFailedDetailView.redpacket_id_label.text = self.authRedPacketResult.data.redpacket_id;
        if (self.authRedPacketResult.data.payStatus.integerValue == 6) {////支付失败，需要重新支付
            self.redPacketPrepareFailedDetailView.confirmProcessLabel.text = NSLocalizedString(@"未被主网确认,款项未扣除", nil);
        }else{
            self.redPacketPrepareFailedDetailView.confirmProcessLabel.text = NSLocalizedString(@"发生未知错误,快去联系小秘书!", nil);
        }
    }
}

- (void)configHeaderViewConfirmBtn{
    switch (self.authRedPacketResult.data.payStatus.integerValue) {
        case 1:////支付成功 可以进行红包的发送
            [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0xd82919)];
            self.headerView.confirmBtn.alpha = 1;
            self.headerView.confirmBtn.enabled = YES;
            [self.headerView.confirmBtn setTitle:NSLocalizedString(@"发出红包", nil) forState:(UIControlStateNormal)];
            break;
        case 4://等待交易确认
            [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0xE05447)];
            self.headerView.confirmBtn.alpha = 0.5;
            self.headerView.confirmBtn.enabled = NO;
            [self.headerView.confirmBtn setTitle:NSLocalizedString(@"红包准备中,请耐心等候", nil) forState:(UIControlStateNormal)];
            break;
        case 6://支付失败，需要重新支付
            [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0x999999)];
            self.headerView.confirmBtn.alpha = 1;
            self.headerView.confirmBtn.enabled = NO;
            [self.headerView.confirmBtn setTitle:NSLocalizedString(@"发生未知错误,快去联系小秘书!", nil) forState:(UIControlStateNormal)];
            break;
            
        default:
            [self.headerView.confirmBtn setBackgroundColor:HEXCOLOR(0x999999)];
            self.headerView.confirmBtn.alpha = 1;
            self.headerView.confirmBtn.enabled = NO;
            [self.headerView.confirmBtn setTitle:NSLocalizedString(@"发生未知错误,快去联系小秘书!", nil) forState:(UIControlStateNormal)];
            self.redPacketPrepareDetailView.redpacket_id_label.text = NSLocalizedString(@"发生未知错误,快去联系小秘书!", nil);
            
            break;
    }
}

- (void)confirmProgressAutoIncreass{
    WS(weakSelf);
    if (self.authRedPacketResult.data.payStatus.integerValue == 1) {
        [self configHeaderViewConfirmBtn];
    }else{
        NSArray *resultArr = [self.authRedPacketResult.data.sureBlockNum componentsSeparatedByString:@"/"];
        if (resultArr.count>1) {
            _currentBlockNum = [(NSString *)resultArr[0] integerValue];
            _mainNetBlockNum = [(NSString *)resultArr[1] integerValue];
            if (_currentBlockNum >= _mainNetBlockNum ) {
                [self performSelector:@selector(requestRedpacketResult) withObject:nil afterDelay:10.0];
            }else{
                dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);
                dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC); // 每秒执行
                dispatch_source_set_event_handler(self.timer, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _currentBlockNum ++;
                        //                    NSLog(@"currentBlockNum:%ld", _currentBlockNum);
                        weakSelf.redPacketPrepareDetailView.confirmProcessLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentBlockNum,_mainNetBlockNum];
                        if (_currentBlockNum >= _mainNetBlockNum) {
                            dispatch_async(queen, ^{
                                // 关闭定时器
                                dispatch_source_cancel(weakSelf.timer);
                                [weakSelf requestRedpacketResult];
                            });
                        }
                    });
                });
                dispatch_resume(self.timer);
            }
        }
    }
}

- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    if (self.authRedPacketResult.data.payStatus.integerValue == 1) {////支付成功 可以进行红包的发送
        NSString *platformName = self.platformNameArr[sender.view.tag-1000];
        NSLog(@"%@", platformName);
        ShareModel *model = [[ShareModel alloc] init];
        model.title = NSLocalizedString(@"天降大红包，没时间解释了，快抢!", nil);
        model.imageName = @"https://pocketeos.oss-cn-beijing.aliyuncs.com/redpacket.png";
        model.detailDescription = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"我下血本为您送上", nil), self.redPacketModel.amount,  self.redPacketModel.coin, NSLocalizedString(@"的大红包，无需消费，直接到达EOS账号，还在犹豫什么？", nil) ];
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

- (void)continueSendRedPacketBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
}

- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}

- (void)cancleShareAccountDetail{
    [self.shareBaseView removeFromSuperview];
}


@end
