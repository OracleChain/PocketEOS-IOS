//
//  ApplicationMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#define ITEMSIZE_WIDTH 75.0f

#import "ApplicationMainViewController.h"
#import "SideBarViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "ApplicationMainHeaderView.h"
#import "ApplicationCollectionViewCell.h"
#import "Application.h"
#import "DAppDetailViewController.h"
#import "ApplicationDetailViewController.h"
#import "NavigationView.h"
#import "ApplicationService.h"
#import "QuestionListViewController.h"
#import "Enterprise.h"
#import "SDCycleScrollView.h"
#import "EnterpriseDetailViewController.h"
#import "CDZPicker.h"
#import "SelectAccountView.h"


@interface ApplicationMainViewController ()<UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NavigationViewDelegate, ApplicationMainHeaderViewDelegate, SDCycleScrollViewDelegate, SelectAccountViewDelegate>

@property(nonatomic, strong) ApplicationMainHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ApplicationService *mainService;
@end

@implementation ApplicationMainViewController



- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:@"应用" rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}

- (ApplicationService *)mainService{
    if (!_mainService) {
        _mainService = [[ApplicationService alloc] init];
    }
    return _mainService;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView registerClass: [ApplicationCollectionViewCell class] forCellWithReuseIdentifier: CELL_REUSEIDENTIFIER];
    self.mainCollectionView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"ApplicationMainHeaderView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Cell_Header"];
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    [self.mainService applicationModuleHeaderRequest:^(id service, BOOL isSuccess) {
        if (weakSelf.mainService.imageURLStringsGroup.count > 0) {
            [weakSelf configBannerView];
        }
        if (weakSelf.mainService.top4DataArray.count > 0) {
            [weakSelf.headerView updateViewWithArray:weakSelf.mainService.top4DataArray];
        }
    }];
    [self.mainService applicationModuleBodyRequest:^(id service, BOOL isSuccess) {
            if (weakSelf.mainService.starDataArray.count > 0) {
                [weakSelf.headerView updateStarViewWithModel:weakSelf.mainService.starDataArray[0]];
                [weakSelf.mainCollectionView reloadData];
            }
    }];
}

- (void)configBannerView{
    WS(weakSelf);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4) delegate:self placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    cycleScrollView.imageURLStringsGroup = weakSelf.mainService.imageURLStringsGroup;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [weakSelf.headerView.cycleScrollView addSubview:cycleScrollView];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    EnterpriseDetailViewController *vc = [[EnterpriseDetailViewController alloc] init];
    Enterprise *model = self.mainService.bannerDataArray[index];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainService.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApplicationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_REUSEIDENTIFIER forIndexPath: indexPath];
    Application *model = (Application *)self.mainService.listDataArray[indexPath.item];
    [cell updateViewWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
    Application *model = (Application *)self.mainService.listDataArray[indexPath.item];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
   
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
     UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            self.headerView = (ApplicationMainHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Cell_Header" forIndexPath:indexPath];
            self.headerView.delegate = self;
            return self.headerView;
        }
    }
    return reusableview;
}


#pragma mark - 侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    [self profileCenter];
}

- (void)profileCenter{
    // 自己随心所欲创建的一个控制器
    SideBarViewController *vc = [[SideBarViewController alloc] init];;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    // 调用这个方法
    [self cw_showDrawerViewController:navi animationType:CWDrawerAnimationTypeMask configuration:nil];
}

// ApplicationMainHeaderViewDelegate
-(void)top4ImgViewDidClick:(UIGestureRecognizer *)sender{
    if (sender.view.tag - 1000 >= 0) {
      Enterprise *model = self.mainService.top4DataArray[sender.view.tag - 1000];
      EnterpriseDetailViewController *vc = [[EnterpriseDetailViewController alloc] init];
      vc.model = model;
      [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)starApplicationBtnDidClick:(UIButton *)sender{
    if (self.mainService.starDataArray.count > 0) {
        Application *application = self.mainService.starDataArray[0];
        if ([application.applyName isEqualToString:@"有问币答"]) {
            QuestionListViewController *vc = [[QuestionListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
