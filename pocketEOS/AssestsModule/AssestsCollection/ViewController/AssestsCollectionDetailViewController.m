//
//  AssestsCollectionDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionDetailViewController.h"
#import "AssestsCollectionDetailHeaderView.h"
#import "AssestsCollectionDetailTableViewCell.h"
#import "ExcuteActions.h"
#import "ExcuteMultipleActionsService.h"
#import "TransactionResult.h"
#import "AssestsCollectionMainService.h"
#import "CommonTransferModel.h"

@interface AssestsCollectionDetailViewController ()<NavigationViewDelegate, ExcuteMultipleActionsServiceDelegate>
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) AssestsCollectionDetailHeaderView *headerView;
@property(nonatomic , strong) AssestsCollectionMainService *assestsCollectionMainService;
@property(nonatomic , strong) ExcuteMultipleActionsService *excuteMultipleActionsService;
@end

@implementation AssestsCollectionDetailViewController


- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 218-62))];
        _backgroundView.image = [UIImage imageNamed:@"assestsCollectionHeaderBackgroundImage"];
    }
    return _backgroundView;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"交易详情", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = [UIColor clearColor];
        _navView.titleLabel.textColor = [UIColor whiteColor];
    }
    return _navView;
}

- (AssestsCollectionDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AssestsCollectionDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 218);
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (AssestsCollectionMainService *)assestsCollectionMainService{
    if (!_assestsCollectionMainService) {
        _assestsCollectionMainService = [[AssestsCollectionMainService alloc] init];
    }
    return _assestsCollectionMainService;
}

- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, 218+62, SCREEN_WIDTH, SCREEN_HEIGHT-218-62);
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView.titleLabel.text = [NSString stringWithFormat:@"%@%lu%@", NSLocalizedString(@"共", nil), (unsigned long)self.transferModelArr.count, NSLocalizedString(@"笔交易", nil)];
    
    
    [self.mainTableView reloadData];
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf excuteMultipleActions];
    });
    
}


- (void)excuteMultipleActions{
    WS(weakSelf);
    [self.assestsCollectionMainService buildExcuteActionsArrayWithTransferModel:self.transferModelArr andComplete:^(id service, BOOL isSuccess) {
        //weakSelf.assestsCollectionMainService.dataSourceArray.count
        for (int i = 0; i < weakSelf.assestsCollectionMainService.dataSourceArray.count;  i++) {
            ExcuteActions *action = weakSelf.assestsCollectionMainService.dataSourceArray[i];
            
            AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:action.actor];
            if (accountInfo) {
                ExcuteMultipleActionsService *excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
                excuteMultipleActionsService.delegate = self;
                excuteMultipleActionsService.tag = action.actor;
                [excuteMultipleActionsService excuteMultipleActionsWithSender:action.actor andExcuteActionsArray:[NSArray arrayWithObject:action] andAvailable_keysArray:@[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)] andPassword: self.password];
            }else{
                [TOASTVIEW showWithText: NSLocalizedString(@"您钱包中暂无操作账号~", nil)];
            }
        }
    }];
    
    
}

//ExcuteMultipleActionsServiceDelegate
- (void)excuteMultipleActionsDidFinish:(TransactionResult *)result{
    /**
     status :comleted , faild , handling
     */
    if ([result.code isEqualToNumber:@0]) {
        NSLog(@"%@ 成功", result.transaction_id);
        for (CommonTransferModel *model in self.transferModelArr) {
            if ([model.from isEqualToString:result.tag]) {
                model.status = @"comleted";
                model.resultStr = [NSString stringWithFormat:@"%@%@ %@", NSLocalizedString(@"交易成功，共转出", nil) ,model.amount , model.symbol];
            }
        }
    }else{
        NSLog(@"%@ 失败", result.message);
        for (CommonTransferModel *model in self.transferModelArr) {
            if ([model.from isEqualToString:result.tag]) {
                model.status = @"faild";
                model.resultStr = [NSString stringWithFormat:@"%@%@ %@", NSLocalizedString(@"交易失败", nil), model.amount , model.symbol];
            }
        }
        
    }
    [self.mainTableView reloadData];
    NSLog(@"result.tag ::  %@\n result.transaction_id :: %@\n result.message:: %@\n", result.tag, result.transaction_id, result.message);
}


// UITableViewDelegate && DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssestsCollectionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[AssestsCollectionDetailTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    CommonTransferModel *model = self.transferModelArr[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transferModelArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
