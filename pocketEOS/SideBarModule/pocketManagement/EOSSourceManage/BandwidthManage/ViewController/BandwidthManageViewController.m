//
//  BandwidthManageViewController.m
//  pocketEOS
//
//  Created by 师巍巍 on 21/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BandwidthManageViewController.h"
#import "BandwidthManageHeaderView.h"
#import "BandwidthManageTableViewCell.h"
#import "EOSResource.h"
#import "BandwidthManageCellModel.h"
#import "EOSResourceService.h"

@interface BandwidthManageViewController ()
@property(nonatomic , strong) BandwidthManageHeaderView *headerView;
@end

@implementation BandwidthManageViewController

- (BandwidthManageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BandwidthManageHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
        //        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.mainTableView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    [self.mainTableView registerNib:[UINib nibWithNibName:@"BandwidthManageTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_REUSEUDENTIFIER1];
    [self buildDataSource];
}

- (void)buildDataSource{
    if (self.dataSourceArray.count >= 2) {
        BandwidthManageCellModel *cpu_model = self.dataSourceArray[0];
        BandwidthManageCellModel *net_model = self.dataSourceArray[1];
        NSArray *cpuArr = [cpu_model.weight componentsSeparatedByString:@" "];
        NSArray *netArr = [net_model.weight componentsSeparatedByString:@" "];
        if (cpuArr.count>0 && netArr.count > 0) {
            NSString *cpuStr = cpuArr[0];
            NSString *netStr = netArr[0];
            self.headerView.eosAmountLabel.text = [NSString stringWithFormat:@"%.4f", cpuStr.doubleValue + netStr.doubleValue];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BandwidthManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BandwidthManageTableViewCell"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"BandwidthManageTableViewCell" owner:self options:nil].firstObject;
    }
    BandwidthManageCellModel *model = self.dataSourceArray[indexPath.section];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 147;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    BaseBoldLineView *view = [[BaseBoldLineView alloc] init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


@end
