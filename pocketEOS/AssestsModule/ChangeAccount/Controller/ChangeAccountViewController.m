//
//  ChangeAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ChangeAccountViewController.h"
#import "NavigationView.h"
#import "RichListCell.h"
#import "Account.h"
#import "WalletAccount.h"
#import "Follow.h"

@interface ChangeAccountViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource,NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation ChangeAccountViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"切换账号" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RichListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[RichListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    if (self.changeAccountDataArrayType == ChangeAccountDataArrayTypeLocal) {
        AccountInfo *accountInfo = self.dataArray[indexPath.row];
        cell.accountInfo = accountInfo;
    }else if (self.changeAccountDataArrayType == ChangeAccountDataArrayTypeNetworking){
        WalletAccount *walletAccount = self.dataArray[indexPath.row];
        cell.walletAccount = walletAccount;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *accountName = nil;
    if (self.changeAccountDataArrayType == ChangeAccountDataArrayTypeLocal) {
        AccountInfo *accountInfo = self.dataArray[indexPath.row];
        accountName = accountInfo.account_name;
    }else if (self.changeAccountDataArrayType == ChangeAccountDataArrayTypeNetworking){
        WalletAccount *walletAccount = self.dataArray[indexPath.row];
        accountName = walletAccount.eosAccountName;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAccountCellDidClick:)]) {
        [self.delegate changeAccountCellDidClick:accountName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
