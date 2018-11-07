//
//  TransferDetailsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "TransferDetailsService.h"
#import "TransferDetailsTableViewCell.h"
#import "TransferDetailsHeaderView.h"
#import "DAppDetailViewController.h"
#import "DappModel.h"

@interface TransferDetailsViewController ()
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) TransferDetailsService *mainService;
@property(nonatomic , strong) TransferDetailsHeaderView *headerView;
@property(nonatomic , strong) UIView *footerView;
@end

@implementation TransferDetailsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"转账详情", nil)rightBtnTitleName:nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (TransferDetailsService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferDetailsService alloc] init];
    }
    return _mainService;
}

- (TransferDetailsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferDetailsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 83);
    }
    return _headerView;
}

//- (UIView *)footerView{
//    if (!_footerView) {
//        _footerView = [[UIView alloc] init];
//
//        UIButton *btn = [[UIButton alloc] init];
//        [btn setTitle:NSLocalizedString(@"到浏览器中查看详情", nil) forState:(UIControlStateNormal)];
//        [btn setTitleColor:HEXCOLOR(0x668FFF) forState:UIControlStateNormal];
//        btn.font = [UIFont systemFontOfSize:12];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn addTarget:self action:@selector(footerBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
//        btn.frame = CGRectMake(0, MARGIN_10, SCREEN_WIDTH, 15);
//        [_footerView addSubview:btn];
//
//    }
//    return _footerView;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    [self.mainTableView setTableHeaderView:self.headerView];
    
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.mainService.model = self.model;
    
    
    if ([CURRENT_ACCOUNT_NAME isEqualToString:self.model.from]) {
        self.headerView.amountLabel.text = [NSString stringWithFormat:@"-%@",  self.model.amount];
//        self.headerView.amountLabel.textColor = LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE ? HEXCOLOR(0xFFFFFF ) : HEXCOLOR(0x140F26 );
    }else if([CURRENT_ACCOUNT_NAME isEqualToString:self.model.to]){
        self.headerView.amountLabel.text = [NSString stringWithFormat:@"+%@",  self.model.amount];
//        self.amountLabel.textColor = HEXCOLOR(0xE903C);
    }
    self.headerView.symbolNameLabel.text = self.model.assestsType;
    
    WS(weakSelf);
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        [weakSelf.mainTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[TransferDetailsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    OptionModel *model;
    if (indexPath.section == 0) {
        NSArray *firstSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"firstSecionModelArr"];
        model = firstSecionModelArr[indexPath.row];
    }else if (indexPath.section == 1){
        NSArray *secondSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"secondSecionModelArr"];
        model = secondSecionModelArr[indexPath.row];
    }else if (indexPath.section == 2){
        NSArray *thirdSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"thirdSecionModelArr"];
        model = thirdSecionModelArr[indexPath.row];
    }else if (indexPath.section == 3){
        NSArray *fourthSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"fourthSecionModelArr"];
        model = fourthSecionModelArr[indexPath.row];
    }
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionModel *model;
    if (indexPath.section == 0) {
        NSArray *firstSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"firstSecionModelArr"];
        model = firstSecionModelArr[indexPath.row];
    }else if (indexPath.section == 1){
        NSArray *secondSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"secondSecionModelArr"];
        model = secondSecionModelArr[indexPath.row];
    }else if (indexPath.section == 2){
        NSArray *thirdSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"thirdSecionModelArr"];
        model = thirdSecionModelArr[indexPath.row];
    }else if (indexPath.section == 3){
        NSArray *fourthSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"fourthSecionModelArr"];
        model = fourthSecionModelArr[indexPath.row];
    }
    
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TransferDetailsTableViewCell class]  contentViewWidth:SCREEN_WIDTH];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionModel *model;
    if (indexPath.section == 0) {
        NSArray *firstSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"firstSecionModelArr"];
        model = firstSecionModelArr[indexPath.row];
    }else if (indexPath.section == 1){
        NSArray *secondSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"secondSecionModelArr"];
        model = secondSecionModelArr[indexPath.row];
    }else if (indexPath.section == 2){
        NSArray *thirdSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"thirdSecionModelArr"];
        model = thirdSecionModelArr[indexPath.row];
    }else if (indexPath.section == 3){
        NSArray *fourthSecionModelArr = [self.mainService.dataSourceDictionary objectForKey:@"fourthSecionModelArr"];
        model = fourthSecionModelArr[indexPath.row];
    }
    if (model.canCopy) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string =VALIDATE_STRING(model.detail);
        [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *firstArr = [self.mainService.dataSourceDictionary objectForKey:@"firstSecionModelArr"];
        return firstArr.count;
    }else if (section ==  1){
        NSArray *secondArr = [self.mainService.dataSourceDictionary objectForKey:@"secondSecionModelArr"];
        return secondArr.count;
    }else if (section ==  2){
        NSArray *thirdArr = [self.mainService.dataSourceDictionary objectForKey:@"thirdSecionModelArr"];
        return thirdArr.count;
    }else if (section ==  3){
        NSArray *thirdArr = [self.mainService.dataSourceDictionary objectForKey:@"fourthSecionModelArr"];
        return thirdArr.count;
    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainService.dataSourceDictionary.allKeys.count;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:NSLocalizedString(@"到浏览器中查看详情", nil) forState:(UIControlStateNormal)];
        [btn setTitleColor:HEXCOLOR(0x668FFF) forState:UIControlStateNormal];
        btn.font = [UIFont systemFontOfSize:12];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(footerBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(0, MARGIN_10, SCREEN_WIDTH, 40);
        return btn;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 40;
    }
    return 0;
}

- (void)footerBtnDidClick{
    DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
    DappModel *model = [[DappModel alloc] init];
    model.dappUrl = [NSString stringWithFormat:@"https://eosflare.io/tx/%@", self.model.trxid];
    model.dappName = @"eosflare";
    vc.model = model;
    vc.choosedAccountName = CURRENT_ACCOUNT_NAME;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else {
        return MARGIN_10;
    }
    return 0;
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
