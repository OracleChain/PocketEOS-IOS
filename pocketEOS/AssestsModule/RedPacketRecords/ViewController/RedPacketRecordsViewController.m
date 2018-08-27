//
//  RedPacketRecordsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketRecordsViewController.h"
#import "TransferRecordsHeaderView.h"
#import "RedpacketService.h"
#import "RedPacketDetailViewController.h"
#import "RedPacketModel.h"
#import "RedPacketRecord.h"


@interface RedPacketRecordsViewController ()<TransferRecordsHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) TransferRecordsHeaderView *headerView;
@property(nonatomic , strong) RedpacketService *mainService;

@end

@implementation RedPacketRecordsViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"红包记录", nil)rightBtnImgName:nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (TransferRecordsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferRecordsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (RedpacketService *)mainService{
    if (!_mainService) {
        _mainService = [[RedpacketService alloc] init];
    }
    return _mainService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 40);
    [self.view addSubview:self.mainTableView];
    
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
    [self requestRedPacketRecords];
}

- (void)requestRedPacketRecords{
    self.mainService.getRedPacketRecordRequest.uid = CURRENT_WALLET_UID;
    self.mainService.getRedPacketRecordRequest.account = CURRENT_ACCOUNT_NAME;
    self.mainService.getRedPacketRecordRequest.type = self.currentAssestsType;
    [self loadNewData];
}

- (void)selectAssestsBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    NSArray *assestsArr = @[@"EOS" , @"OCT"];
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    for (int i = 0 ; i < assestsArr.count; i++) {
        NSString *assest = assestsArr[i];
        if ([assest isEqualToString:self.currentAssestsType]) {
            builder.defaultIndex = i;
        }
    }
    
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:assestsArr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.currentAssestsType = VALIDATE_STRING(strings[0]);
        weakSelf.headerView.assestChooserLabel.text = weakSelf.currentAssestsType;
        weakSelf.mainService.getRedPacketRecordRequest.type = weakSelf.currentAssestsType;
        [weakSelf requestRedPacketRecords];
    }cancel:^{
        NSLog(@"user cancled");
    }];
    
}


// UITableViewDelegate && DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RedPacketRecord *model = self.mainService.dataSourceArray[indexPath.row];
    if (model.isSend == YES) {
        //        [model.residueCount isEqualToNumber:@0] ? NSLocalizedString(@"全部被领取", nil): [NSString stringWithFormat: @"%@%ld%@", NSLocalizedString(@"已被", nil), model.packetCount.integerValue - model.residueCount.integerValue,NSLocalizedString(@"人领取", nil) ]
        NSString *str;
        if ([model.residueCount isEqualToNumber:@0]) {
            str = NSLocalizedString(@"全部被领取", nil);
        }else{
            str = [NSString stringWithFormat: @"%@%ld%@", NSLocalizedString(@"已被", nil), model.packetCount.integerValue - model.residueCount.integerValue,NSLocalizedString(@"人领取", nil) ];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@, %@",NSLocalizedString(@"发送", nil), model.amount, NSLocalizedString(@"个", nil),model.type, NSLocalizedString(@"给", nil),model.packetCount,NSLocalizedString(@"个人", nil), str];
        
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"领取", nil), model.amount, NSLocalizedString(@"个", nil), model.type];
    }
    //    cell.textLabel.frame = CGRectMake(MARGIN_20, MARGIN_20, SCREEN_WIDTH-(MARGIN_20*2), 21);
    cell.detailTextLabel.text =model.createTime;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = HEXCOLOR(0x2A2A2A);
    cell.detailTextLabel.textColor = HEXCOLOR(0xB0B0B0);
    cell.bottomLineView.hidden = NO;
    if (indexPath.row == self.mainService.dataSourceArray.count-1) {
        cell.bottomLineView.hidden = YES;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketDetailViewController *vc = [[RedPacketDetailViewController alloc] init];
    RedPacketModel *model = [[RedPacketModel alloc] init];
    model.from = CURRENT_ACCOUNT_NAME;
//    model.count = self.headerView.redPacketCountTF.text;
//    model.memo =   self.headerView.memoTV.text;
//    model.amount = self.headerView.amountTF.text;
    
    RedPacketRecord *record = self.mainService.dataSourceArray[indexPath.row];
    model.redPacket_id = record.redPacket_id;
    model.verifystring = record.verifyString;
    model.amount = record.amount;
    model.isSend = record.isSend;
    model.coin = record.type;
    vc.redPacketModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71.5;
}



// NavigationView delegate
- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableView + 下拉刷新 隐藏时间 + 上拉加载
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    [self.mainTableView.mj_footer resetNoMoreData];
    
    [self.mainService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshing];
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark 上拉加载更多数据
//- (void)loadMoreData
//{
//    WS(weakSelf);
//    [self.mainService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
//        if (isSuccess) {
//            // 刷新表格
//            [weakSelf.mainTableView reloadData];
//            if ([dataCount isEqualToNumber:@0]) {
//                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                // 拿到当前的下拉刷新控件，结束刷新状态
//                [weakSelf.mainTableView.mj_footer endRefreshing];
//            }
//        }else{
//            [weakSelf.mainTableView.mj_header endRefreshing];
//            [weakSelf.mainTableView.mj_footer endRefreshing];
//        }
//    }];
//}

@end
