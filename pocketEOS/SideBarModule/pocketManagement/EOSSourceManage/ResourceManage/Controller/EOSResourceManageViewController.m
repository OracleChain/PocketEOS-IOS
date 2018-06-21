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


@interface EOSResourceManageViewController ()<PageSegmentViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) EOSResourceService *mainService;
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) PageSegmentView *segmentView;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
   
//    self.view.lee_theme
//    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
//    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.mainService.getAccountRequest.name = self.currentAccountName;
    [self.mainService get_account:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.mainService.dataSourceArray.count >= 2) {
                EOSResourceCellModel *cpu_model = weakSelf.mainService.dataSourceArray[0];
                EOSResourceCellModel *net_model = weakSelf.mainService.dataSourceArray[1];
                NSArray *cpuArr = [cpu_model.weight componentsSeparatedByString:@" "];
                NSArray *netArr = [net_model.weight componentsSeparatedByString:@" "];
                if (cpuArr.count>0 && netArr.count > 0) {
                    NSString *cpuStr = cpuArr[0];
                    NSString *netStr = netArr[0];
//                    weakSelf.headerView.eosAmountLabel.text = [NSString stringWithFormat:@"%.4f", cpuStr.doubleValue + netStr.doubleValue];
                    
                }
                BandwidthManageViewController *vc1 = [[BandwidthManageViewController alloc]init];
                vc1.dataSourceArray = weakSelf.mainService.dataSourceArray;
                [_allVC addObject:vc1];
                vc1.title = @"带宽管理";
                
                StorageManageViewController *vc2 = [[StorageManageViewController alloc]init];
                [_allVC addObject:vc2];
                vc2.title = @"存储管理";
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
