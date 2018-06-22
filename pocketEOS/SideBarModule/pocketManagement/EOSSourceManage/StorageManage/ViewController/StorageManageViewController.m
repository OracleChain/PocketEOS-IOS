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

@interface StorageManageViewController ()<StorageManageHeaderViewDelegate>
@property(nonatomic , strong) StorageManageHeaderView *headerView;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
    self.view.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    [self buildDataSource];
}

- (void)buildDataSource{
    CGFloat progress = self.eosResourceResult.data.ram_usage.doubleValue/self.eosResourceResult.data.ram_max.doubleValue;
    self.headerView.progressView.progress = progress;
    self.headerView.tipLabel.text = [NSString stringWithFormat:@"存储配额使用情况(%@byte/%@byte)", self.eosResourceResult.data.ram_usage, self.eosResourceResult.data.ram_max];
}


//StorageManageHeaderViewDelegate
-(void)buyRamBtnDidClick:(UIButton *)sender{
    TradeRamViewController *vc = [[TradeRamViewController alloc] init];
    vc.pageType = @"buy_ram";
    vc.eosResourceResult = self.eosResourceResult;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sellRamBtnDidClick:(UIButton *)sender{
    TradeRamViewController *vc = [[TradeRamViewController alloc] init];
    vc.pageType = @"sell_ram";
    vc.eosResourceResult = self.eosResourceResult;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
