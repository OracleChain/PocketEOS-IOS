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
#import "BandwidthManageViewController.h"
#import "StorageManageViewController.h"
#import "PageSegmentView.h"
#import "GetAccountAssetRequest.h"
#import "AccountResult.h"


@interface EOSResourceManageViewController ()<PageSegmentViewDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) EOSResourceService *mainService;
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) PageSegmentView *segmentView;
@property(nonatomic, strong) GetAccountAssetRequest *getAccountAssetRequest;
@property(nonatomic , strong) AccountResult *currentAccountResult;

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
        self.segmentView = [[PageSegmentView alloc]initWithFrame:CGRectMake(0,NAVIGATIONBAR_HEIGHT,self.view.width,self.view.height - NAVIGATIONBAR_HEIGHT)];
        self.segmentView.selectedLineWidth = 60;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [self getAccountAssest];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.mainService.getAccountRequest.name = self.currentAccountName;
    [self.mainService get_account:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.mainService.dataSourceArray.count >= 2) {
                BandwidthManageViewController *vc1 = [[BandwidthManageViewController alloc]init];
                vc1.title = @"带宽管理";
                vc1.navigationController = self.navigationController;
                vc1.accountResult = weakSelf.currentAccountResult;
                [vc1.navigationController.navigationBar setHidden: YES];
                [_allVC addObject:vc1];
                
                StorageManageViewController *vc2 = [[StorageManageViewController alloc]init];
                vc2.title = @"存储管理";
                vc2.navigationController = self.navigationController;
                [vc2.navigationController.navigationBar setHidden: YES];
                vc2.accountResult = weakSelf.currentAccountResult;
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

@end
