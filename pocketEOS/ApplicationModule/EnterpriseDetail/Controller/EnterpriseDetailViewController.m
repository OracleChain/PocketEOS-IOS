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

@interface EnterpriseDetailViewController ()<UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) EnterpriseDetailHeaderView *headerView;
@property(nonatomic, strong) EnterpriseDetailService *mainService;
@end

@implementation EnterpriseDetailViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"应用详情" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
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
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView registerClass: [ApplicationCollectionViewCell class] forCellWithReuseIdentifier: CELL_REUSEUDENTIFIER1];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"EnterpriseDetailHeaderView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Cell_Header3"];
    
    WS(weakSelf);
    self.mainService.getEnterpriseDetailRequest.enterprise_id = self.model.enterprise_id;
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.mainService.recommandApplicationDataArray.count> 0) {
                [weakSelf.headerView upadteRecommandViewWithModel:weakSelf.mainService.recommandApplicationDataArray[0]];
            }
            [weakSelf.mainCollectionView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApplicationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_REUSEUDENTIFIER1 forIndexPath: indexPath];
    Application *model = self.mainService.dataSourceArray[indexPath.item];
    [cell updateViewWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@"  , indexPath);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
           self.headerView = (EnterpriseDetailHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Cell_Header3" forIndexPath:indexPath];
            [self.headerView updateViewWithModel:self.model];
            return self.headerView;
        }
    }
    return reusableview;
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
