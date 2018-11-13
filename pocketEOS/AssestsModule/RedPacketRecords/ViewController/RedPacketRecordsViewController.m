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
#import "RedPacketRecordsTableViewCell.h"
#import "ForwardRedPacketViewController.h"
#import "TokenInfo.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestRedPacketRecords];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 40);
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_footer.hidden = YES;
    
    self.headerView.assestChooserLabel.text = self.currentAssestsType;
}

- (void)requestRedPacketRecords{

    self.mainService.getRedPacketRecordRequest.account = CURRENT_ACCOUNT_NAME;
    self.mainService.getRedPacketRecordRequest.type = self.currentAssestsType;
    [self loadNewData];
}

- (void)selectAssestsBtnDidClick:(UIButton *)sender{
    WS(weakSelf);
    NSArray *tmpArr = [ArchiveUtil unarchiveTokenInfoArray];
    
    
    NSMutableArray *assestsArr = [NSMutableArray arrayWithObjects:SymbolName_EOS, SymbolName_OCT  ,nil];
    for (TokenInfo *tokenInfo in tmpArr) {
        if ([tokenInfo.token_symbol isEqualToString:SymbolName_CET] && [tokenInfo.contract_name isEqualToString:ContractName_EOSIOCHAINCE]) {
            [assestsArr addObject:SymbolName_CET];
        }
    }
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.cancelText = NSLocalizedString(@"选择您的Token", nil);
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
    RedPacketRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[RedPacketRecordsTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    RedPacketRecord *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketRecord *record = self.mainService.dataSourceArray[indexPath.row];
    
    RedPacketModel *model = [[RedPacketModel alloc] init];
    model.from = CURRENT_ACCOUNT_NAME;
    model.count = record.packetCount.stringValue;
    model.memo =   record.memo;
    //    model.amount = self.headerView.amountTF.text;
    model.redPacket_id = record.redPacket_id;
    model.verifystring = record.verifyString;
    model.amount = record.amount;
    model.isSend = record.isSend;
    model.coin = record.type;
    model.status = record.status;
    
    if (record.isSend == YES) {
        if (record.status.integerValue == 1) {//等待主网确认
            ForwardRedPacketViewController *forwardRedPacketVC = [[ForwardRedPacketViewController alloc] init];
            forwardRedPacketVC.redPacketModel = model;
            [self.navigationController pushViewController:forwardRedPacketVC animated:YES];
        }else if(record.status.integerValue == 0 || record.status.integerValue == 2 || record.status.integerValue == 3 || record.status.integerValue == 4 || record.status.integerValue == 5 ){
            RedPacketDetailViewController *vc = [[RedPacketDetailViewController alloc] init];
            vc.redPacketModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        RedPacketDetailViewController *vc = [[RedPacketDetailViewController alloc] init];
        vc.redPacketModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
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
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_header endRefreshing];
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
        }
    }];
}


@end
