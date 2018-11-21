
//
//  AssestsMainAddAccountView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsMainAddAccountView.h"
#import "AddAccountMainService.h"
#import "AddAccountTableViewCell.h"
#import "ImportAccountViewController.h"
#import "VipRegistAccountViewController.h"
#import "PayRegistAccountViewController.h"
#import "CreateAccountViewController.h"
#import "CheckWhetherHasFreeQuotaResuest.h"
#import "CheckWhetherHasFreeQuotaResult.h"
#import "CommonDialogHasTitleView.h"
#import "CreatePocketViewController.h"
#import "ImportAccountWithoutAccountNameBaseViewController.h"

@interface AssestsMainAddAccountView ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic , strong) UITableView *mainTableView;
@property(nonatomic , strong) AddAccountMainService *mainService;
@property(nonatomic , strong) CheckWhetherHasFreeQuotaResuest *checkWhetherHasFreeQuotaResuest;
@property(nonatomic , strong) CheckWhetherHasFreeQuotaResult *checkWhetherHasFreeQuotaResult;
@property(nonatomic , strong) UILabel *titleLabel;
@end

@implementation AssestsMainAddAccountView

- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _mainTableView.separatorColor = HEX_RGB(0xEEEEEE);
            
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _mainTableView.separatorColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
        }
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _mainTableView.scrollsToTop = YES;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}


- (CheckWhetherHasFreeQuotaResuest *)checkWhetherHasFreeQuotaResuest{
    if (!_checkWhetherHasFreeQuotaResuest) {
        _checkWhetherHasFreeQuotaResuest = [[CheckWhetherHasFreeQuotaResuest alloc] init];
    }
    return _checkWhetherHasFreeQuotaResuest;
}

- (AddAccountMainService *)mainService{
    if (!_mainService) {
        _mainService = [[AddAccountMainService alloc] init];
    }
    return _mainService;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = NSLocalizedString(@"选择账号添加方式", nil);
        _titleLabel.backgroundColor= [UIColor clearColor];
    }
    return _titleLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lee_theme.LeeConfigBackgroundColor(@"baseAddAccount_background_color");
        
        [self addSubview:self.titleLabel];
        _titleLabel.frame = CGRectMake(MARGIN_20, 100, 200, 20);
        
        [self addSubview:self.mainTableView];
        self.mainTableView.frame = CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        WS(weakSelf);
        [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
            [weakSelf.mainTableView reloadData];
        }];
        [self checkWhetherHasFreeQuota];
    }
    return self;
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
    
    Wallet *wallet = [[[WalletTableManager walletTable] selectCurrentWallet] firstObject];
//    if (wallet && (wallet.wallet_shapwd.length <= 6)) {
//        [self addCommonDialogHasTitleView];
//        return;
//    }
    OptionModel *model = self.mainService.dataSourceArray[indexPath.row];
    if ([model.optionName isEqualToString:NSLocalizedString(@"导入账号", nil)]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(importAccount)]) {
            [self.delegate importAccount];
        }
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"创建账号", nil)]){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(payRegist)]) {
            [self.delegate payRegist];
        }
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"我是VIP", nil)]){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(vipRegist)]) {
            [self.delegate vipRegist];
        }
    }else if ([model.optionName isEqualToString:NSLocalizedString(@"限时免费", nil)]){
        if (self.checkWhetherHasFreeQuotaResult.data == YES) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(freeCreateAccount)]) {
                [self.delegate freeCreateAccount];
            }
        }else{
            [TOASTVIEW showWithText:self.checkWhetherHasFreeQuotaResult.message];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
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

//- (void)addCommonDialogHasTitleView{
//    [self addSubview:self.commonDialogHasTitleView];
//
//    self.commonDialogHasTitleView.contentTextView.textAlignment = NSTextAlignmentCenter;
//    self.commonDialogHasTitleView.comfirmBtnText = NSLocalizedString(@"去设置", nil);
//
//    OptionModel *model = [[OptionModel alloc] init];
//    model.optionName = NSLocalizedString(@"注意", nil);
//    model.detail = NSLocalizedString(@"设置钱包密码继续操作", nil);
//    [self.commonDialogHasTitleView setModel:model];
//}



@end
