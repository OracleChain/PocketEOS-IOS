//
//  EOSResourceManageViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceManageViewController.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"
#import "EOSResourceService.h"
#import "EOSResourceResult.h"
#import "BandwidthManageViewController.h"
#import "StorageManageViewController.h"
#import "PageSegmentView.h"
#import "GetAccountAssetRequest.h"
#import "AccountResult.h"
#import "CommonDialogHasTitleView.h"
#import "DAppDetailViewController.h"
#import "DappModel.h"
#import "CpuNetManageViewController.h"
#import "RamManageViewController.h"

@interface EOSResourceManageViewController ()<PageSegmentViewDelegate, UINavigationControllerDelegate, CommonDialogHasTitleViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) EOSResourceService *mainService;
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) PageSegmentView *segmentView;
@property(nonatomic, strong) GetAccountAssetRequest *getAccountAssetRequest;
@property(nonatomic , strong) AccountResult *currentAccountResult;
@property(nonatomic , strong) CommonDialogHasTitleView *commonDialogHasTitleView;
@end


@implementation EOSResourceManageViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"资源管理", nil) rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (EOSResourceService *)mainService{
    if (!_mainService) {
        _mainService = [[EOSResourceService alloc] init];
    }
    return _mainService;
}

- (PageSegmentView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[PageSegmentView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT,self.view.width,self.view.height - STATUSBAR_HEIGHT)];
        self.segmentView.selectedLineWidth = 24;
        self.segmentView.tabViewWidth = SCREEN_WIDTH;
        self.segmentView.delegate = self;
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

-(NSMutableArray *)allVC{
    if (!_allVC) {
        _allVC = [NSMutableArray array];
    }
    return _allVC;  
}

- (GetAccountAssetRequest *)getAccountAssetRequest{
    if (!_getAccountAssetRequest) {
        _getAccountAssetRequest = [[GetAccountAssetRequest alloc] init];
    }
    return _getAccountAssetRequest;
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
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.navView];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    self.title = @"sww";
    
    
    [self getAccountAssest];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.mainService.getAccountRequest.name = self.currentAccountName;
    [self.mainService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            
//                BandwidthManageViewController *vc1 = [[BandwidthManageViewController alloc]init];
                CpuNetManageViewController *vc1 = [[CpuNetManageViewController alloc]init];
                            vc1.eosResourceResult = result;
                vc1.title = NSLocalizedString(@"抵押管理", nil);
                vc1.accountResult = weakSelf.currentAccountResult;
                vc1.navigationController = self.navigationController;
                [vc1.navigationController.navigationBar setHidden: YES];
                [_allVC addObject:vc1];
                
//                StorageManageViewController *vc2 = [[StorageManageViewController alloc]init];
                RamManageViewController *vc2 = [[RamManageViewController alloc]init];
            vc2.eosResourceResult = result;
                vc2.title = NSLocalizedString(@"内存管理", nil);
                vc2.navigationController = self.navigationController;
                vc2.accountResult = weakSelf.currentAccountResult;
                [vc2.navigationController.navigationBar setHidden: YES];
                [_allVC addObject:vc2];
                _allVC = [NSMutableArray arrayWithObjects:vc1 , vc2, nil];
                weakSelf.segmentView.delegate = self;
                // 可自定义背景色和tab button的文字颜色等
                // _segmentView.selectedLineWidth = 50;
                // 开始构建UI
                [_segmentView buildUI];
                // 显示红点，点击消失
//                [_segmentView showRedDotWithIndex:0];
                
        }
        
    }];
}

- (void)getAccountAssest{
    WS(weakSelf);
    self.getAccountAssetRequest.name = self.currentAccountName;
    [self.getAccountAssetRequest postDataSuccess:^(id DAO, id data) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            AccountResult *result = [AccountResult mj_objectWithKeyValues:data];
            weakSelf.currentAccountResult = result;
            [weakSelf buildDataSource];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - DBPagerTabView Delegate

- (NSUInteger)numberOfPagers:(PageSegmentView *)view {
    return [_allVC count];
}

- (UIViewController *)pagerViewOfPagers:(PageSegmentView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)pageSegmentleftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pageSegmentRightBtnDidClick{
    [self.view addSubview:self.commonDialogHasTitleView];
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"注意", nil);
    model.detail = NSLocalizedString(@"您正在跳转至第三方Dapp,确认即同意第三方Dapp的用户协议与隐私政策，由其直接并单独向您承担责任", nil);
    [self.commonDialogHasTitleView setModel:model];
}

- (void)commonDialogHasTitleViewConfirmBtnDidClick:(UIButton *)sender{
    DAppDetailViewController *vc = [[DAppDetailViewController alloc] init];
    DappModel *model = [[DappModel alloc] init];
    model.dappUrl = [NSString stringWithFormat:@"https://cpuemergency.com/embed_oraclechain.html"];
    model.dappName = NSLocalizedString(@"账号救援", nil);
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
