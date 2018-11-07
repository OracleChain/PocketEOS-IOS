//
//  EnterpriseDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//
#define ITEMSIZE_WIDTH 75.0f
#import "EnterpriseDetailViewController.h"
#import "EnterpriseDetailHeaderView.h"
#import "ApplicationCollectionViewCell.h"
#import "Application.h"
#import "Enterprise.h"
#import "NavigationView.h"
#import "CDZPicker.h"
#import "EnterpriseDetailService.h"
#import "DAppDetailViewController.h"
#import "QuestionListViewController.h"

@interface EnterpriseDetailViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, EnterpriseDetailHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) EnterpriseDetailHeaderView *headerView;
@property(nonatomic, strong) EnterpriseDetailService *mainService;
@property(nonatomic, strong) UICollectionView *mainCollectionView;
@end

@implementation EnterpriseDetailViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"企业详情", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (EnterpriseDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EnterpriseDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 338 + CYCLESCROLLVIEW_HEIGHT);
        [_headerView updateViewWithModel:self.model];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (EnterpriseDetailService *)mainService{
    if (!_mainService) {
        _mainService = [[EnterpriseDetailService alloc] init];
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
    
    WS(weakSelf);
    self.mainService.getEnterpriseDetailRequest.enterprise_id = self.model.enterprise_id;
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.mainService.recommandApplicationDataArray.count> 0) {
                [weakSelf.headerView upadteRecommandViewWithModel:weakSelf.mainService.recommandApplicationDataArray[0]];
            }
            [weakSelf.mainTableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Application *model = (Application *)self.mainService.dataSourceArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ApplicationCollectionViewCell class]  contentViewWidth:SCREEN_WIDTH ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplicationCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[ApplicationCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    Application *model = (Application *)self.mainService.dataSourceArray[indexPath.item];
//    cell.model = model;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Application *model = (Application *)self.mainService.dataSourceArray[indexPath.item];
    
    if ([model.applyName isEqualToString:NSLocalizedString(@"有问币答", nil)]) {
        QuestionListViewController *vc = [[QuestionListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

//EnterpriseDetailHeaderViewDelegate
- (void)recommandBtnDidClick:(UIButton *)sender{
    if (self.mainService.recommandApplicationDataArray.count > 0) {
        Application *model = self.mainService.recommandApplicationDataArray[0];
     
            if ([model.applyName isEqualToString:NSLocalizedString(@"有问币答", nil)]) {
                QuestionListViewController *vc = [[QuestionListViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        
        
        
        
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
