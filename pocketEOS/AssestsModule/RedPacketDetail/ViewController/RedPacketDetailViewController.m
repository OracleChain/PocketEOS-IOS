//
//  RedPacketDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketDetailViewController.h"
#import "RedPacketDetailHeaderView.h"
#import "RedpacketService.h"
#import "RedPacketRecord.h"
#import "RedPacketDetail.h"
#import "RedPacketDetailSingleAccount.h"
#import "RedPacketDetailService.h"
#import "RedPacketDetailSingleAccount.h"
#import "TransferService.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "SocialSharePanelView.h"
#import "SocialManager.h"
#import "SocialShareModel.h"
#import "ShareModel.h"
#import "RedPacketDetail.h"
#import "RedPacketRecordsTableViewCell.h"
#import "TransferRecordsTableViewCell.h"

@interface RedPacketDetailViewController ()<RedPacketDetailHeaderViewDelegate, SocialSharePanelViewDelegate>
@property(nonatomic , strong) NavigationView *navView;
@property(nonatomic , strong) RedPacketDetailHeaderView *headerView;
@property(nonatomic , strong) RedpacketService *redpacketService;
@property(nonatomic , strong) RedPacketDetailService  *mainService;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic , strong) UIView *shareBaseView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@property(nonatomic , strong) RedPacketDetail *redPacketDetailResult;
@end

@implementation RedPacketDetailViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"红包", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = RGB(214, 62, 67);
        _navView.titleLabel.textColor = [UIColor whiteColor];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal);
    }
    return _navView;
}

- (RedPacketDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RedPacketDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (RedpacketService *)redpacketService{
    if (!_redpacketService) {
        _redpacketService = [[RedpacketService alloc] init];
    }
    return _redpacketService;
}

- (RedPacketDetailService *)mainService{
    if (!_mainService) {
        _mainService = [[RedPacketDetailService alloc] init];
    }
    return _mainService;
}
- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
    }
    return _transferService;
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
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.headerView.accountNameLabel.text = self.redPacketModel.from;
    self.headerView.memoLabel.text = self.redPacketModel.memo;

    if (self.redPacketModel.isSend) {
        // 发送
        self.headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT , SCREEN_WIDTH, 370);
        self.navView.titleLabel.text = NSLocalizedString(@"发红包", nil);
        
        
        
        
    }else{
        // 领取
        self.headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT , SCREEN_WIDTH, 300);
        self.navView.titleLabel.text = NSLocalizedString(@"领红包", nil);
        self.headerView.sendRedpacketBtn.hidden = YES;
        [self.headerView.amountLabel sd_clearAutoLayoutSettings];

        self.headerView.amountLabel.sd_layout.topSpaceToView(self.headerView.memoLabel, MARGIN_15).leftSpaceToView(self.headerView, MARGIN_20).rightSpaceToView(self.headerView, MARGIN_15).heightIs(33);
        self.headerView.tipLabel.sd_layout.topSpaceToView(self.headerView.amountLabel, MARGIN_15).leftSpaceToView(self.headerView, MARGIN_20).rightSpaceToView(self.headerView, MARGIN_15).heightIs(13);
    }
    
    [self getRate];
    [self buildDataSource];
    
}


- (void)buildDataSource{
    WS(weakSelf);
    self.redpacketService.getRedPacketDetailRequest.redPacket_id = self.redPacketModel.redPacket_id;
    [self.redpacketService getRedPacketDetail:^(RedPacketDetail *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.redPacketDetailResult = result;
            weakSelf.redpacketService.dataSourceArray = [NSMutableArray arrayWithArray:result.redPacketOrderRedisDtos];
            [weakSelf.mainTableView reloadData];
            if (weakSelf.redPacketModel.isSend) {
                // 发送
                weakSelf.headerView.recordLabel.text = [NSString stringWithFormat:@"%@%ld/%@%@，%@ %@ %@",NSLocalizedString(@"已领取", nil), result.packetCount.integerValue - result.residueCount.integerValue , result.packetCount,NSLocalizedString(@"个", nil),NSLocalizedString(@"剩余", nil), result.residueAmount, weakSelf.redPacketModel.coin];
                
                if (weakSelf.redPacketModel.status.integerValue == 0 ||weakSelf.redPacketModel.status.integerValue == 3 ) {////正常可以领取(包含领取完毕的红包)
                    if ([result.residueCount isEqualToNumber:@0]) {
                        weakSelf.headerView.sendRedpacketBtn.enabled = NO;
                        [weakSelf.headerView.sendRedpacketBtn setBackgroundColor:HEXCOLOR(0xCCCCCC)];
                        [weakSelf.headerView.sendRedpacketBtn setTitle:NSLocalizedString(@"红包已抢完", nil) forState:(UIControlStateNormal)];
                    }else{
                        weakSelf.headerView.sendRedpacketBtn.enabled = YES;
                        [weakSelf.headerView.sendRedpacketBtn setBackgroundColor:HEXCOLOR(0xD82919)];
                        [weakSelf.headerView.sendRedpacketBtn setTitle:NSLocalizedString(@"继续发红包", nil) forState:(UIControlStateNormal)];
                    }
                    
                }else if (weakSelf.redPacketModel.status.integerValue == 5 ){////发送失败
                    weakSelf.headerView.sendRedpacketBtn.enabled = NO;
                    [weakSelf.headerView.sendRedpacketBtn setBackgroundColor:HEXCOLOR(0xCCCCCC)];
                    [weakSelf.headerView.sendRedpacketBtn setTitle:NSLocalizedString(@"发送失败", nil) forState:(UIControlStateNormal)];
                }else if (weakSelf.redPacketModel.status.integerValue == 4 ){////已经退回
                    weakSelf.headerView.sendRedpacketBtn.enabled = NO;
                    [weakSelf.headerView.sendRedpacketBtn setBackgroundColor:HEXCOLOR(0xCCCCCC)];
                    [weakSelf.headerView.sendRedpacketBtn setTitle:NSLocalizedString(@"已退回", nil) forState:(UIControlStateNormal)];
                }else if (weakSelf.redPacketModel.status.integerValue == 2 ){//已经过期但是还没退回
                    weakSelf.headerView.sendRedpacketBtn.enabled = NO;
                    [weakSelf.headerView.sendRedpacketBtn setBackgroundColor:HEXCOLOR(0xCCCCCC)];
                    [weakSelf.headerView.sendRedpacketBtn setTitle:NSLocalizedString(@"已过期", nil) forState:(UIControlStateNormal)];
                }
            }else{
                // 领取
                weakSelf.headerView.amountLabel.text = [NSString stringWithFormat:@"%@ %@", weakSelf.redPacketModel.amount , weakSelf.redPacketModel.coin];
                weakSelf.headerView.tipLabel.text = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"领取的", nil), weakSelf.redPacketModel.coin, NSLocalizedString(@"已经存入您的主账号", nil)];
                weakSelf.headerView.recordLabel.text = [NSString stringWithFormat:@"%@%ld/%@%@，%@ %@ %@",NSLocalizedString(@"已领取", nil), result.packetCount.integerValue - result.residueCount.integerValue , result.packetCount,NSLocalizedString(@"个", nil),NSLocalizedString(@"剩余", nil), result.residueAmount, weakSelf.redPacketModel.coin];
            }
            
        }
        weakSelf.mainTableView.mj_header.hidden = YES;
        [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)getRate{
    WS(weakSelf);
    if ([self.redPacketModel.coin isEqualToString:@"EOS"]) {
        self.transferService.getRateRequest.coinmarket_id = @"eos";
    }else if ([self.redPacketModel.coin isEqualToString:@"OCT"]){
        self.transferService.getRateRequest.coinmarket_id = @"oraclechain";
    }
    [self.transferService get_rate:^(GetRateResult *result, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.redPacketModel.isSend) {
                weakSelf.headerView.amountLabel.text = [NSString stringWithFormat:@"≈%@CNY" , [NumberFormatter displayStringFromNumber:@(weakSelf.redPacketModel.amount.doubleValue * result.data.price_cny.doubleValue)]];
            }
        }
    }];
}

// UITableViewDelegate && DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransferRecordsTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RedPacketDetailSingleAccount *model = self.redpacketService.dataSourceArray[indexPath.row];
    cell.redPacketDetailSingleAccount = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.redpacketService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71.5;
}

//RedPacketDetailHeaderViewDelegate
- (void)sendRedPacketBtnDidClick{
    [self.view addSubview:self.shareBaseView];
    self.shareBaseView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(SCREEN_HEIGHT);
}

// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    ShareModel *model = [[ShareModel alloc] init];
    model.title = NSLocalizedString(@"天降大红包，没时间解释了，快抢!", nil);
    model.imageName = @"https://pocketeos.oss-cn-beijing.aliyuncs.com/redpacket.png";
    model.detailDescription = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"我下血本为您送上", nil), self.redPacketDetailResult.amount,  self.redPacketModel.coin, NSLocalizedString(@"的大红包，无需消费，直接到达EOS账号，还在犹豫什么？", nil) ];
    model.webPageUrl = [NSString stringWithFormat:@"http://static.pocketeos.top:8003?id=%@&verifystring=%@",self.redPacketModel.redPacket_id,self.redPacketModel.verifystring];
    NSLog(@"model.webPageUrl : %@", model.webPageUrl);
    if ([platformName isEqualToString:@"wechat_friends"]) {
       [[SocialManager socialManager] wechatShareToScene:0 withShareModel:model];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
       [[SocialManager socialManager] wechatShareToScene:1 withShareModel:model];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [TOASTVIEW showWithText:@"暂不支持~"];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [TOASTVIEW showWithText:@"暂不支持~"];
    }
}

- (void)dismiss{
    [self.shareBaseView removeFromSuperview];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancleShareAccountDetail{
    [self.shareBaseView removeFromSuperview];
}

@end
