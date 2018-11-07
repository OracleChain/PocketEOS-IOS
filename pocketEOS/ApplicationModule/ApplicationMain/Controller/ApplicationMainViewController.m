//
//  ApplicationMainViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#define ITEMSIZE_WIDTH 75.0f
#define ACTION_STARAPP_CLICK @"ACTION_STARAPP_CLICK"
#define ACTION_CELL_ITEM_CLICK @"ACTION_CELL_ITEM_CLICK"

#import "ApplicationMainViewController.h"
#import "SideBarViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "ApplicationMainHeaderView.h"
#import "ApplicationCollectionViewCell.h"
#import "Application.h"
#import "DAppDetailViewController.h"
#import "NavigationView.h"
#import "ApplicationService.h"
#import "QuestionListViewController.h"
#import "Enterprise.h"
#import "SDCycleScrollView.h"
#import "EnterpriseDetailViewController.h"
#import "CDZPicker.h"
#import "SelectAccountView.h"
#import "ApplicationHeaderView.h"
#import "CommonDialogHasTitleView.h"



@interface ApplicationMainViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, ApplicationMainHeaderViewDelegate, SDCycleScrollViewDelegate, SelectAccountViewDelegate, ApplicationHeaderViewDelegate, CommonDialogHasTitleViewDelegate>

@property(nonatomic, strong) ApplicationHeaderView *headerView;
@property(nonatomic, strong) NavigationView *navView;

@property(nonatomic, strong) ApplicationService *mainService;
@property(nonatomic , strong) CommonDialogHasTitleView *commonDialogHasTitleView;
@property(nonatomic , copy) NSString *currentAction;
@property(nonatomic , strong) Application *model;
@end

@implementation ApplicationMainViewController



- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:NSLocalizedString(@"发现", nil)rightBtnImgName:@"" delegate:self];
    }
    return _navView;
}

- (ApplicationHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ApplicationHeaderView alloc] init];
        if (self.mainService.top4DataArray.count > 0) {
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 310 + CYCLESCROLLVIEW_HEIGHT);
        }else{
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206-9.5 + CYCLESCROLLVIEW_HEIGHT );
        }
        _headerView.delegate = self;
        ApplicationHeaderViewModel *model = [[ApplicationHeaderViewModel alloc] init];
        model.top4DataArray = (NSMutableArray *)self.mainService.top4DataArray;
        model.starDataArray = (NSMutableArray *)self.mainService.starDataArray;
//        [self configBannerView];
        [self.headerView updateViewWithModel:model];
    }
    return _headerView;
}



- (ApplicationService *)mainService{
    if (!_mainService) {
        _mainService = [[ApplicationService alloc] init];
    }
    return _mainService;
}


- (CommonDialogHasTitleView *)commonDialogHasTitleView{
    if (!_commonDialogHasTitleView) {
        _commonDialogHasTitleView = [[CommonDialogHasTitleView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _commonDialogHasTitleView.delegate = self;
    }
    return _commonDialogHasTitleView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT- TABBAR_HEIGHT);
    
    self.mainTableView.mj_footer.hidden = YES;
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_group_enter(dispatchGroup);
    [weakSelf.mainService applicationModuleHeaderRequest:^(id service, BOOL isSuccess) {
         dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    [weakSelf.mainService applicationModuleBodyRequest:^(id service, BOOL isSuccess) {
         dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        [weakSelf.mainTableView.mj_header endRefreshing];
        [self.mainTableView setTableHeaderView:self.headerView];
        [weakSelf.mainTableView reloadData];
        [weakSelf configBannerView];
    });
}

- (void)configBannerView{
    WS(weakSelf);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CYCLESCROLLVIEW_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    cycleScrollView.imageURLStringsGroup = weakSelf.mainService.imageURLStringsGroup;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [weakSelf.headerView addSubview:cycleScrollView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.listDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Application *model = (Application *)self.mainService.listDataArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ApplicationCollectionViewCell class]  contentViewWidth:SCREEN_WIDTH ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplicationCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[ApplicationCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    Application *model = (Application *)self.mainService.listDataArray[indexPath.item];
//    cell.model = model;
    return cell;
   
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [MobClick event:[NSString stringWithFormat:@"DApp_banner_%ld", index+1]];
    EnterpriseDetailViewController *vc = [[EnterpriseDetailViewController alloc] init];
    Enterprise *model = self.mainService.bannerDataArray[index];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addCommonDialogHasTitleView];
    self.currentAction = ACTION_CELL_ITEM_CLICK;
    
    Application *model = (Application *)self.mainService.listDataArray[indexPath.item];
    
    self.model = model;
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
    [self addCommonDialogHasTitleView];
    self.currentAction = ACTION_STARAPP_CLICK;
}

- (void)loadNewData{
    [self buildDataSource];
}


//CommonDialogHasTitleViewDelegate
- (void)commonDialogHasTitleViewConfirmBtnDidClick:(UIButton *)sender{
    if ([self.currentAction isEqualToString:ACTION_STARAPP_CLICK]) {
        if (self.mainService.starDataArray.count > 0) {
            Application *model = self.mainService.starDataArray[0];
            [self handleCommonDialogHasTitleViewConfirmBtnDidClickResult:model];
        }
    }else if ([self.currentAction isEqualToString:ACTION_CELL_ITEM_CLICK]){
        [self handleCommonDialogHasTitleViewConfirmBtnDidClickResult:self.model];
    }
    
}

- (void)handleCommonDialogHasTitleViewConfirmBtnDidClickResult:(Application *)model{
    if ([model.applyName isEqualToString:NSLocalizedString(@"有问币答", nil)]) {
        QuestionListViewController *vc = [[QuestionListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addCommonDialogHasTitleView{
    [self.view addSubview:self.commonDialogHasTitleView];
    
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"注意", nil);
    model.detail = NSLocalizedString(@"您正在跳转至第三方Dapp,确认即同意第三方Dapp的用户协议与隐私政策，由其直接并单独向您承担责任", nil);
    [self.commonDialogHasTitleView setModel:model];
}

@end
