//
//  StorageManageViewController.m
//  pocketEOS
//
//  Created by 师巍巍 on 21/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "StorageManageViewController.h"
#import "StorageManageHeaderView.h"
#import "ModifyApproveViewController.h"
#import "TradeRamViewController.h"
#import "EOSResourceService.h"

NSString * const TradeRamDidSuccessNotification = @"TradeRamDidSuccessNotification";

@interface StorageManageViewController ()<StorageManageHeaderViewDelegate>
@property(nonatomic , strong) StorageManageHeaderView *headerView;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@property(nonatomic , strong) EOSResourceService *eosResourceService;

@end

@implementation StorageManageViewController

- (StorageManageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"StorageManageHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320);
        _headerView.delegate = self;
    }
    return _headerView;
}
- (EOSResourceResult *)eosResourceResult{
    if (!_eosResourceResult) {
        _eosResourceResult = [[EOSResourceResult alloc] init];
    }
    return _eosResourceResult;
}
- (EOSResourceService *)eosResourceService{
    if (!_eosResourceService) {
        _eosResourceService = [[EOSResourceService alloc] init];
    }
    return _eosResourceService;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildDataSource];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
    self.view.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    [self buildDataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tradeRamDidFinish) name:TradeRamDidSuccessNotification object:nil];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.eosResourceService.getAccountRequest.name = self.accountResult.data.account_name;
    [self.eosResourceService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.eosResourceResult = result;
            CGFloat progress = weakSelf.eosResourceResult.data.ram_usage.doubleValue/weakSelf.eosResourceResult.data.ram_max.doubleValue;
            weakSelf.headerView.progressView.progress = progress;
            weakSelf.headerView.tipLabel.text = [NSString stringWithFormat:@"存储配额使用情况(%@byte/%@byte)", weakSelf.eosResourceResult.data.ram_usage, weakSelf.eosResourceResult.data.ram_max];
        }
    }];
}


//StorageManageHeaderViewDelegate
-(void)buyRamBtnDidClick:(UIButton *)sender{
    TradeRamViewController *vc = [[TradeRamViewController alloc] init];
    vc.pageType = @"buy_ram";
    vc.eosResourceResult = self.eosResourceResult;
    vc.accountResult = self.accountResult;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sellRamBtnDidClick:(UIButton *)sender{
    TradeRamViewController *vc = [[TradeRamViewController alloc] init];
    vc.pageType = @"sell_ram";
    vc.eosResourceResult = self.eosResourceResult;
    vc.accountResult = self.accountResult;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tradeRamDidFinish{
    [self buildDataSource];
}

@end
