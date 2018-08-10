//
//  AddAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AddAccountViewController.h"
#import "AddAccountMainService.h"
#import "AddAccountTableViewCell.h"
#import "ImportAccountViewController.h"
#import "VipRegistAccountViewController.h"
#import "PayRegistAccountViewController.h"
#import "CreateAccountViewController.h"
#import "CheckWhetherHasFreeQuotaResuest.h"
#import "CheckWhetherHasFreeQuotaResult.h"

@interface AddAccountViewController ()
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) AddAccountMainService *mainService;
@property(nonatomic , strong) CheckWhetherHasFreeQuotaResuest *checkWhetherHasFreeQuotaResuest;
@property(nonatomic , strong) CheckWhetherHasFreeQuotaResult *checkWhetherHasFreeQuotaResult;
@end

@implementation AddAccountViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"添加账号", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    }
    return _navView;
}

- (AddAccountMainService *)mainService{
    if (!_mainService) {
        _mainService = [[AddAccountMainService alloc] init];
    }
    return _mainService;
}

- (CheckWhetherHasFreeQuotaResuest *)checkWhetherHasFreeQuotaResuest{
    if (!_checkWhetherHasFreeQuotaResuest) {
        _checkWhetherHasFreeQuotaResuest = [[CheckWhetherHasFreeQuotaResuest alloc] init];
    }
    return _checkWhetherHasFreeQuotaResuest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    self.mainTableView.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self checkWhetherHasFreeQuota];
    WS(weakSelf);
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        [weakSelf.mainTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[AddAccountTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    OptionModel *model = self.mainService.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90+5+5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionModel *model = self.mainService.dataSourceArray[indexPath.row];
    if ([model.optionName isEqualToString:NSLocalizedString(@"导入EOS账号", nil)]) {
        ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"付费创建", nil)]){
        PayRegistAccountViewController *vc = [[PayRegistAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"我是VIP", nil)]){
        VipRegistAccountViewController *vc = [[VipRegistAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"限时免费", nil)]){
        if (self.checkWhetherHasFreeQuotaResult.data == YES) {
            CreateAccountViewController *vc = [[CreateAccountViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [TOASTVIEW showWithText:self.checkWhetherHasFreeQuotaResult.message];
        }
    }
}

- (void)checkWhetherHasFreeQuota{
    WS(weakSelf);
    [self.checkWhetherHasFreeQuotaResuest getDataSusscess:^(id DAO, id data) {
        CheckWhetherHasFreeQuotaResult *result = [CheckWhetherHasFreeQuotaResult mj_objectWithKeyValues:data];
        weakSelf.checkWhetherHasFreeQuotaResult = result;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
