//
//  EOSResourceManageViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceManageViewController.h"
#import "EOSResourceManageHeaderView.h"
#import "EOSResourceManageTableViewCell.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"
#import "EOSResourceService.h"

@interface EOSResourceManageViewController ()
@property(nonatomic , strong) EOSResourceManageHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) EOSResourceService *mainService;
@end


@implementation EOSResourceManageViewController

- (EOSResourceManageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EOSResourceManageHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 194);
//        _headerView.delegate = self;
    }
    return _headerView;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资源管理", nil) rightBtnImgName:@"share" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (EOSResourceService *)mainService{
    if (!_mainService) {
        _mainService = [[EOSResourceService alloc] init];
    }
    return _mainService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.mainTableView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    [self.mainTableView registerNib:[UINib nibWithNibName:@"EOSResourceManageTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_REUSEUDENTIFIER1];
     [self.headerView updateViewWithArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"带宽管理", nil), NSLocalizedString(@"存储管理", nil),  nil]];
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.mainService.getAccountRequest.name = self.currentAccountName;
    [self.mainService get_account:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.mainService.dataSourceArray.count >= 2) {
                EOSResourceCellModel *cpu_model = weakSelf.mainService.dataSourceArray[0];
                EOSResourceCellModel *net_model = weakSelf.mainService.dataSourceArray[1];
                NSArray *cpuArr = [cpu_model.weight componentsSeparatedByString:@" "];
                NSArray *netArr = [net_model.weight componentsSeparatedByString:@" "];
                if (cpuArr.count>0 && netArr.count > 0) {
                    NSString *cpuStr = cpuArr[0];
                    NSString *netStr = netArr[0];
                    weakSelf.headerView.eosAmountLabel.text = [NSString stringWithFormat:@"%.4f", cpuStr.doubleValue + netStr.doubleValue];
                    
                }
                [weakSelf.mainTableView reloadData];
            }
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EOSResourceManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EOSResourceManageTableViewCell"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"EOSResourceManageTableViewCell" owner:self options:nil].firstObject;
    }
    EOSResourceCellModel *model = self.mainService.dataSourceArray[indexPath.section];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainService.dataSourceArray.count;
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

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
