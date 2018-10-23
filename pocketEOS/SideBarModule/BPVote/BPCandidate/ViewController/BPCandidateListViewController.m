//
//  BPCandidateListViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateListViewController.h"
#import "BPCandidateFooterView.h"
#import "BPCandidateTableViewCell.h"
#import "BPCandidateService.h"
#import "BPVoteAmountViewController.h"
#import "BPCandidateModel.h"
#import "BPCandidateDetailViewController.h"
#import "RtfBrowserWithoutThemeViewController.h"

@interface BPCandidateListViewController ()<NavigationViewDelegate, BPCandidateFooterViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) BPCandidateFooterView *footerView;
@property(nonatomic , strong) BPCandidateService *mainService;
@property(nonatomic , strong) NSMutableArray *choosedBPDataArray;
@property(nonatomic , strong) NSMutableArray *choosedBPNameDataArray;

@end

@implementation BPCandidateListViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView =  [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"节点投票", nil)rightBtnTitleName:NSLocalizedString(@"投票规则", nil)delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
        [_navView.rightBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
    }
    return _navView;
}

- (BPCandidateFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"BPCandidateFooterView" owner:nil options:nil] firstObject];
        _footerView.frame = CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        _footerView.delegate = self;
    }
    return _footerView;
}

- (BPCandidateService *)mainService{
    if (!_mainService) {
        _mainService = [[BPCandidateService alloc] init];
    }
    return _mainService;
}
- (Account *)model{
    if (!_model) {
        _model = [[Account alloc] init];
    }
    return _model;
}

- (NSMutableArray *)choosedBPDataArray{
    if (!_choosedBPDataArray) {
        _choosedBPDataArray = [NSMutableArray array];
    }
    return _choosedBPDataArray;
}

- (NSMutableArray *)choosedBPNameDataArray{
    if (!_choosedBPNameDataArray) {
        _choosedBPNameDataArray = [NSMutableArray array];
    }
    return _choosedBPNameDataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0x000000);
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = HEXCOLOR(0x000000);
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT);
    [self.view addSubview:self.footerView];
    [self.mainTableView.mj_header beginRefreshing];
    
    
    for (BPCandidateModel *votedModel in self.myVoteInfoResult.producers){
        [self.choosedBPNameDataArray addObject:votedModel.owner];
    }
    
    [self configFooterView];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BPCandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BPCandidateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    BPCandidateModel *model = self.mainService.dataSourceArray[indexPath.row];
    
    //NSArray或者NSMutableArray常见错误was mutated while being enumerated
    //forin 循环中的便利内容不能被改变, 是因为如果改变其便利的内容会少一个, 而系统是不会允许这个发生的所以就会crash...但是当改变最后一个的内容时, 就不会crash, 是因为此时遍历已经结束, 结束之后对内容做修改是允许的
//    NSArray *tmpArr = [NSArray arrayWithArray:self.choosedBPNameDataArray];
//    for (NSString *bpName in tmpArr) {
//        if ([bpName isEqualToString:model.owner]) {
//            if (![self.choosedBPDataArray containsObject:model] ) {
//                [self.choosedBPDataArray addObject:model];
//                [self.choosedBPNameDataArray removeObject:bpName];
//                model.isSelected = YES;
//            }
//        }
//    }
    
    
    cell.model = model;
    [cell setOnAvatarViewClick:^{
        BPCandidateDetailViewController *vc = [[BPCandidateDetailViewController alloc] init];
        if ([model.url hasPrefix: @"http"]) {
            vc.urlStr = model.url;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [TOASTVIEW showWithText:NSLocalizedString(@"链接地址有误!", nil)];
        }
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BPCandidateModel *model = self.mainService.dataSourceArray[indexPath.row];
    if (self.choosedBPNameDataArray.count == 30) {
        [TOASTVIEW showWithText:NSLocalizedString(@"最多选取30个节点", nil)];
    }else{
        if (model.voted) {
            if ([self.choosedBPNameDataArray containsObject:model.owner]) {
                [self.choosedBPNameDataArray removeObject:model.owner];
                model.voted = NO;
            }
        }else{
            if (![self.choosedBPNameDataArray containsObject:model.owner]) {
                [self.choosedBPNameDataArray addObject:model.owner];
                model.voted = YES;
            }
        }
    }
    [self.mainTableView reloadData];
    [self configFooterView];
}

- (void)configFooterView{
    NSInteger remainCount = 30-self.choosedBPNameDataArray.count;
    self.footerView.tipLabel.text = [NSString stringWithFormat:@"%@%ld%@%ld%@", NSLocalizedString(@"已选择", nil),self.choosedBPNameDataArray.count, NSLocalizedString(@"个，还可以选择", nil), remainCount , NSLocalizedString(@"个", nil)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//BPCandidateFooterViewDelegate
- (void)confirmBtnDidClick{
    if (self.choosedBPNameDataArray.count == 0) {
        [TOASTVIEW showWithText:@"至少选择一个投票节点!"];
        return ;
    }
    BPVoteAmountViewController *vc = [[BPVoteAmountViewController alloc] init];
    vc.model = self.model;
    vc.choosedBPNameDataArray = self.choosedBPNameDataArray;
    vc.myVoteInfoResult = self.myVoteInfoResult;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    RtfBrowserWithoutThemeViewController *vc = [[RtfBrowserWithoutThemeViewController alloc] init];
    vc.rtfFileName = @"BPVoteRules";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    WS(weakSelf);
    self.mainService.getBPCandidateListRequest.accountName = self.model.account_name;
    [self.mainTableView.mj_footer resetNoMoreData];
    [self.mainService buildDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                
                [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
            }else if(dataCount.integerValue < PER_PAGE_SIZE_15){
                // 拿到当前的下拉刷新控件，结束刷新状态
                [IMAGE_TIP_LABEL_MANAGER removeImageAndTipLabelViewManager];
            }
            [weakSelf.mainTableView.mj_header setHidden:YES];
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithSocial_Mode_ImageName:@"nomoredata" andBlackbox_Mode_ImageName:@"nomoredata_BB" andTitleStr:NSLocalizedString(@"暂无数据", nil)toView:weakSelf.mainTableView andViewController:weakSelf];
        }
    }];
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    WS(weakSelf);
    self.mainService.getBPCandidateListRequest.accountName = self.model.account_name;
    [self.mainService buildNextPageDataSource:^(NSNumber *dataCount, BOOL isSuccess) {
        if (isSuccess) {
            // 刷新表格
            [weakSelf.mainTableView reloadData];
            if ([dataCount isEqualToNumber:@0]) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [weakSelf.mainTableView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.mainTableView.mj_footer endRefreshing];
        }
    }];
}

@end
