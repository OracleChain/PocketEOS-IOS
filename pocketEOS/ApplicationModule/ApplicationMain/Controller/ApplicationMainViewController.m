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
#import "ApplicationHeaderView.h"


@interface ApplicationMainViewController ()<UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NavigationViewDelegate, ApplicationMainHeaderViewDelegate, SDCycleScrollViewDelegate, SelectAccountViewDelegate, ApplicationHeaderViewDelegate>

@property(nonatomic, strong) ApplicationHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ApplicationService *mainService;
@property(nonatomic, strong) UICollectionView *mainCollectionView;
@end

@implementation ApplicationMainViewController



- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:@"发现" rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}

- (ApplicationService *)mainService{
    if (!_mainService) {
        _mainService = [[ApplicationService alloc] init];
    }
    return _mainService;
}

- (UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize: CGSizeMake(SCREEN_WIDTH / 2 - 1, 66)];
        
        if (self.mainService.top4DataArray.count > 0) {
            layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 310 + SCREEN_WIDTH * 0.40 );
        }else{
            layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 206 + SCREEN_WIDTH * 0.40 );
        }
        
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) collectionViewLayout: layout];
        _mainCollectionView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        [_mainCollectionView setDataSource: self];
        [_mainCollectionView setDelegate: self];
        [_mainCollectionView setShowsVerticalScrollIndicator: NO];
        
        [_mainCollectionView registerClass: [ApplicationCollectionViewCell class] forCellWithReuseIdentifier: CELL_REUSEIDENTIFIER];
//        [_mainCollectionView registerNib:[UINib nibWithNibName:@"ApplicationHeaderView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Cell_Header"];
        [_mainCollectionView registerClass:[ApplicationHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Cell_Header"];
        
    }
    return _mainCollectionView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildDataSource];
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    [self.view addSubview:self.navView];
    
    [self buildDataSource];
    
}

- (void)buildDataSource{
    WS(weakSelf);
    ApplicationHeaderViewModel *model = [[ApplicationHeaderViewModel alloc] init];
    [weakSelf.mainService applicationModuleHeaderRequest:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            //界面刷新
            [weakSelf.view addSubview:weakSelf.mainCollectionView];
            [weakSelf configBannerView];
            if (weakSelf.mainService.listDataArray) {
                model.top4DataArray = (NSMutableArray *)weakSelf.mainService.top4DataArray;
                [weakSelf.headerView updateViewWithModel:model];
            }
        }
    }];
    [weakSelf.mainService applicationModuleBodyRequest:^(id service, BOOL isSuccess) {
        model.starDataArray = (NSMutableArray *)weakSelf.mainService.starDataArray;
        [weakSelf.headerView updateViewWithModel:model];
        [weakSelf.mainCollectionView reloadData];
    }];
}

- (void)configBannerView{
    WS(weakSelf);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4) delegate:self placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    cycleScrollView.imageURLStringsGroup = weakSelf.mainService.imageURLStringsGroup;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [weakSelf.headerView addSubview:cycleScrollView];
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
    Application *model = (Application *)self.mainService.listDataArray[indexPath.item];
    
    if ([model.applyName isEqualToString:@"有问币答"]) {
        QuestionListViewController *vc = [[QuestionListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
   
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
     UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            self.headerView = (ApplicationHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Cell_Header" forIndexPath:indexPath];
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
        Application *model = self.mainService.starDataArray[0];
        if ([model.applyName isEqualToString:@"有问币答"]) {
            QuestionListViewController *vc = [[QuestionListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)loadNewData{
    
}
@end
