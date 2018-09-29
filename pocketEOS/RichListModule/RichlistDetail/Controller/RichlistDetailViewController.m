//
//  RichlistDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "RichlistDetailViewController.h"
#import "NavigationView.h"
#import "RichlistDetailHeaderView.h"
#import "RichlistDetailService.h"
#import "AccountResult.h"
#import "ChangeAccountViewController.h"
#import "TransferNewViewController.h"
#import "AssestsDetailViewController.h"
#import "WalletAccountsResult.h"
#import "WalletAccount.h"
#import "ChangeAccountViewController.h"
#import "Follow.h"
#import "AddFollowRequest.h"
#import "CancleFollowRequest.h"
#import "CheckWhetherFollowRequest.h"
#import "AssestsMainTableViewCell.h"
#import "TransferModel.h"
#import "Get_token_info_service.h"
#import "TokenInfo.h"


@interface RichlistDetailViewController ()< UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NavigationViewDelegate, ChangeAccountViewControllerDelegate>
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) RichlistDetailHeaderView *headerView;
@property(nonatomic, strong) RichlistDetailService *mainService;
@property(nonatomic, strong) Get_token_info_service *get_token_info_service;
@property(nonatomic, strong) AddFollowRequest *addFollowRequest;
@property(nonatomic, strong) CancleFollowRequest *cancleFollowRequest;
@property(nonatomic, strong) CheckWhetherFollowRequest *checkWhetherFollowRequest;
// 是否已经关注账号或钱包
@property(nonatomic, assign) BOOL whetherFollow;
@end

@implementation RichlistDetailViewController

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 250))];
        _backgroundView.image = [UIImage imageNamed:@"background_black"];
    }
    return _backgroundView;
}


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [[NavigationView alloc] initNavigationViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)) LeftBtnImgName:@"back_white" titleImage:@"PocketEOS" rightImgName:@"addFollow" delegate:self];
    }
    return _navView;
}


- (RichlistDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"RichlistDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 296);
        _headerView.backgroundColor = [UIColor clearColor];
        
    }
    return _headerView;
}


- (RichlistDetailService *)mainService{
    if (!_mainService) {
        _mainService = [[RichlistDetailService alloc] init];
    }
    return _mainService;
}

- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (AddFollowRequest *)addFollowRequest{
    if (!_addFollowRequest) {
        _addFollowRequest = [[AddFollowRequest alloc] init];
    }
    return _addFollowRequest;
}
- (CancleFollowRequest *)cancleFollowRequest{
    if (!_cancleFollowRequest) {
        _cancleFollowRequest = [[CancleFollowRequest alloc] init];
    }
    return _cancleFollowRequest;
}
- (CheckWhetherFollowRequest *)checkWhetherFollowRequest{
    if (!_checkWhetherFollowRequest) {
        _checkWhetherFollowRequest = [[CheckWhetherFollowRequest alloc] init];
    }
    return _checkWhetherFollowRequest;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    WS(weakSelf);
    // 检查是否已经关注
    self.checkWhetherFollowRequest.fuid = CURRENT_WALLET_UID;
    if ([self.model.followType isEqualToNumber:@1]) {
        // 钱包
        self.checkWhetherFollowRequest.followType = @1;
        self.checkWhetherFollowRequest.uid = self.model.uid;
        [self.checkWhetherFollowRequest postDataSuccess:^(id DAO, id data) {
             weakSelf.whetherFollow = VALIDATE_BOOL([[data objectForKey:@"data"] boolValue]);
            if (weakSelf.whetherFollow) {
                weakSelf.navView.rightImg.image = [UIImage imageNamed:@"cancleFollow"];
            }else{
                weakSelf.navView.rightImg.image = [UIImage imageNamed:@"addFollow"];
            }
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }else if ([self.model.followType isEqualToNumber:@2]){
       // 账号
        self.checkWhetherFollowRequest.followType = @2;
        self.checkWhetherFollowRequest.followTarget = self.model.displayName;
        [self.checkWhetherFollowRequest postDataSuccess:^(id DAO, id data) {
            
            weakSelf.whetherFollow = VALIDATE_BOOL([[data objectForKey:@"data"] boolValue]);
            if (weakSelf.whetherFollow) {
                weakSelf.navView.rightImg.image = [UIImage imageNamed:@"cancleFollow"];
            }else{
                weakSelf.navView.rightImg.image = [UIImage imageNamed:@"addFollow"];
            }
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.mainTableView setTableHeaderView:self.headerView];
    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_footer.hidden = YES;
    [self loadAllBlocks];
}



- (void)buidDataSource{
    WS(weakSelf);
    
    if ([self.model.followType isEqualToNumber:@1]) {
        // 钱包
        self.headerView.userNameLabel.text = [NSString stringWithFormat: @"%@%@", VALIDATE_STRING(self.model.displayName), NSLocalizedString(@"的钱包", nil)];
        [self.headerView.avatarImg sd_setImageWithURL:String_To_URL(self.model.avatar) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
        self.mainService.getWalletAccountsRequest.uid = self.model.uid;
        self.mainService.getWalletAccountsRequest.fuid = CURRENT_WALLET_UID;
        [self.mainService getWalletAccountsRequest:^(WalletAccountsResult *result, BOOL isSuccess) {
            [weakSelf.mainTableView.mj_header endRefreshing];
            if (isSuccess) {
                if (result.data.count == 0) {
                    [TOASTVIEW showWithText: NSLocalizedString(@"该钱包暂无账号!", nil)];
                }else{
                    for (WalletAccount *model in weakSelf.mainService.accountsArray) {
                        if ([model.isMainAccount isEqualToNumber:@1]) {
                            // 获取主账号资产详情
                            if (IsNilOrNull(model.eosAccountName)) {
                                return;
                            }
                           
                            self.get_token_info_service.get_token_info_request.accountName = model.eosAccountName;
                            [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
                                // 拿到当前的下拉刷新控件，结束刷新状态
                                [weakSelf.mainTableView.mj_header endRefreshing];
                                if (isSuccess) {
                                    //            weakSelf.currentAccountResult = result;
//                                                weakSelf.headerView.model = result.data;
                                    [weakSelf.mainTableView reloadData];
                                    [weakSelf.headerView updateViewWithDataArray:weakSelf.get_token_info_service.dataSourceArray];
                                }
                            }];
                            weakSelf.headerView.userAccountLabel.text = model.eosAccountName;
//                            weakSelf.mainService.getAccountAssetRequest.name = model.eosAccountName;
//                            [weakSelf.mainService get_account_asset:^(AccountResult *result, BOOL isSuccess) {
//                                if (isSuccess) {
//                                    weakSelf.headerView.model = result.data;
////                                    [weakSelf.mainTableView reloadData];
//                                }
//                            }] ;
                        }
                    }
                }
            }
        }];
    }else if ([self.model.followType isEqualToNumber:@2]){
        // 账号
        if (IsNilOrNull(self.model.displayName)) {
            return;
        }
        self.headerView.userNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"***的钱包", nil)];
        [self.headerView.avatarImg sd_setImageWithURL:String_To_URL(@"") placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
        self.get_token_info_service.get_token_info_request.accountName = self.model.displayName;
        [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [weakSelf.mainTableView.mj_header endRefreshing];
            if (isSuccess) {
                //            weakSelf.currentAccountResult = result;
                //            weakSelf.headerView.model = result.data;
                [weakSelf.mainTableView reloadData];
                [weakSelf.headerView updateViewWithDataArray:weakSelf.get_token_info_service.dataSourceArray];
            }
        }];
        
        
//        self.mainService.getAccountAssetRequest.name =  self.model.displayName;
        
//        [self.mainService get_account_asset:^(AccountResult *result, BOOL isSuccess) {
//            // 拿到当前的下拉刷新控件，结束刷新状态
//            [weakSelf.mainTableView.mj_header endRefreshing];
//            if (isSuccess) {
//                weakSelf.headerView.model = result.data;
//                weakSelf.headerView.userNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"***的钱包", nil)];
//                [weakSelf.headerView.avatarImg sd_setImageWithURL:String_To_URL(@"") placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
////                [weakSelf.mainTableView reloadData];
//            }
//        }] ;
    }
}

- (void)loadAllBlocks{
    WS(weakSelf);
    // 默认的导航栏 block
    [self.headerView setChangeAccountBtnDidClickBlock:^{
        
        if ([weakSelf.model.followType isEqualToNumber:@1]) {
            // 是钱包才可以点击切换账号
            if (self.mainService.accountsArray.count == 0) {
                [TOASTVIEW showWithText:NSLocalizedString(@"该钱包暂无账号!", nil)];
            }else{
                ChangeAccountViewController *vc = [[ChangeAccountViewController alloc] init];
                vc.dataArray = weakSelf.mainService.accountsArray;
                vc.changeAccountDataArrayType = ChangeAccountDataArrayTypeNetworking;
                vc.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    

    [self.headerView setTransferBtnDidClickBlock:^{
//        if ([weakSelf.model.followType isEqualToNumber:@2]) {
        TransferNewViewController *vc = [[TransferNewViewController alloc] init];
        TransferModel *model = [[TransferModel alloc] init];
        model.account_name = weakSelf.model.displayName;
        if (weakSelf.get_token_info_service.dataSourceArray.count>0) {
            TokenInfo *token = weakSelf.get_token_info_service.dataSourceArray[0];
            model.coin = token.token_symbol;
        }
        vc.transferModel = model;
        vc.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
      return self.get_token_info_service.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssestsMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[AssestsMainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellIdentifier"];
    }
    TokenInfo *model = self.get_token_info_service.dataSourceArray[indexPath.row];
    if ([model.asset_price_change_in_24h hasPrefix:@"-"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%%", model.asset_price_change_in_24h]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0xB51515)
                           range:NSMakeRange(0, model.asset_price_change_in_24h.length + 1)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }else{
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"+%@%%", model.asset_price_change_in_24h]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:HEXCOLOR(0x1E903C)
                           range:NSMakeRange(0, model.asset_price_change_in_24h.length + 2)];
        cell.assestsPriceChangeLabel.attributedText = attrString;
    }
    
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79.5;
}

// navigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    WS(weakSelf);
    self.addFollowRequest.fuid = CURRENT_WALLET_UID;
    self.cancleFollowRequest.fuid = CURRENT_WALLET_UID;
    if ([self.model.followType isEqualToNumber:@1]) {
        if (self.whetherFollow) {
            // 已关注, 钱包 , 则取消关注钱包
            self.cancleFollowRequest.followType = @1;
            self.cancleFollowRequest.uid = self.model.uid;
            [self.cancleFollowRequest postDataSuccess:^(id DAO, id data) {
                if ([data[@"code"] integerValue] == 0) {
                    weakSelf.whetherFollow = NO;
                    weakSelf.navView.rightImg.image = [UIImage imageNamed:@"addFollow"];
                }
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            } failure:^(id DAO, NSError *error) {
                
            }];
        }else{
            // 未关注, 钱包 , 则关注钱包
            self.addFollowRequest.followType = @1;
            self.addFollowRequest.uid = self.model.uid;
            [self.addFollowRequest postDataSuccess:^(id DAO, id data) {
                if ([data[@"code"] integerValue] == 0) {
                    weakSelf.whetherFollow = YES;
                    weakSelf.navView.rightImg.image = [UIImage imageNamed:@"cancleFollow"];
                }
                
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            } failure:^(id DAO, NSError *error) {
                
            }];
        }
    }else if ([self.model.followType isEqualToNumber:@2]){
        if (self.whetherFollow) {
            // 已关注, 账号 , 则取消关注账号
            self.cancleFollowRequest.followType = @2;
            self.cancleFollowRequest.followTarget = self.model.displayName;
            [self.cancleFollowRequest postDataSuccess:^(id DAO, id data) {
                if ([data[@"code"] integerValue] == 0) {
                    weakSelf.whetherFollow = NO;
                    weakSelf.navView.rightImg.image = [UIImage imageNamed:@"addFollow"];
                }
                
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            } failure:^(id DAO, NSError *error) {
                
            }];
        }else{
            // 未关注, 账号 , 则关注账号
            self.addFollowRequest.followType = @2;
            self.addFollowRequest.followTarget = self.model.displayName;
            [self.addFollowRequest postDataSuccess:^(id DAO, id data) {
                if ([data[@"code"] integerValue] == 0) {
                    weakSelf.whetherFollow = YES;
                    weakSelf.navView.rightImg.image = [UIImage imageNamed:@"cancleFollow"];
                }
                
                [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            } failure:^(id DAO, NSError *error) {
                
            }];
        }
    }
}


//ChangeAccountViewControllerDelegate
-(void)changeAccountCellDidClick:(NSString *)name{
    WS(weakSelf);
    if (IsNilOrNull(name)) {
        return;
    }
    self.headerView.userAccountLabel.text = name;
    self.get_token_info_service.get_token_info_request.accountName = name;
    [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.mainTableView.mj_header endRefreshing];
        if (isSuccess) {
            //            weakSelf.currentAccountResult = result;
            //            weakSelf.headerView.model = result.data;
            [weakSelf.mainTableView reloadData];
            [weakSelf.headerView updateViewWithDataArray:weakSelf.get_token_info_service.dataSourceArray];
        }
    }];
}


- (void)loadNewData{
    [self buidDataSource];
    
}
@end
