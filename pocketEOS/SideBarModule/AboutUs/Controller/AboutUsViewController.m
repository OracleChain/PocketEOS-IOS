//
//  AboutUsViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsHeaderView.h"
#import "Get_pocketeos_info_request.h"
#import "Get_pocketeos_info_Result.h"

@interface AboutUsViewController ()<AboutUsHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) AboutUsHeaderView *headerView;
@property(nonatomic , strong) Get_pocketeos_info_request *get_pocketeos_info_request;
@end

@implementation AboutUsViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"关于我们", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (AboutUsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AboutUsHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 490);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (Get_pocketeos_info_request *)get_pocketeos_info_request{
    if (!_get_pocketeos_info_request) {
        _get_pocketeos_info_request = [[Get_pocketeos_info_request alloc] init];
    }
    return _get_pocketeos_info_request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    // 当前版本号
    NSDictionary *infoDic= [[NSBundle mainBundle] infoDictionary];
    
    self.headerView.versionUpdateLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"版本", nil), [infoDic valueForKey:@"CFBundleShortVersionString"]  ];
    self.view.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    
    [self buildDataSource];
}

- (void)buildDataSource{
    WS(weakSelf);
    [self.get_pocketeos_info_request getDataSusscess:^(id DAO, id data) {
        Get_pocketeos_info_Result *result = [Get_pocketeos_info_Result mj_objectWithKeyValues:data];
        [weakSelf.headerView updateViewWithModel:result];
        
        
    } failure:^(id DAO, NSError *error) {
        
    }];
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
