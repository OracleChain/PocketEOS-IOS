//
//  VersionUpdateViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "VersionUpdateViewController.h"
#import "NavigationView.h"
#import "VersionUpdateHeaderView.h"
#import "VersionUpdateTipView.h"
#import "VersionUpdateModel.h"
#import "GetVersionInfoRequest.h"
#import "CommonDialogHasTitleView.h"

@interface VersionUpdateViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, VersionUpdateHeaderViewDelegate, VersionUpdateTipViewDelegate, CommonDialogHasTitleViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) VersionUpdateHeaderView *headerView;
@property(nonatomic , strong) VersionUpdateTipView *versionUpdateTipView;
@property(nonatomic , strong) CommonDialogHasTitleView *commonDialogHasTitleView;
@property(nonatomic , strong) GetVersionInfoRequest *getVersionInfoRequest;
@property(nonatomic , strong) VersionUpdateModel *versionUpdateModel;
@end

@implementation VersionUpdateViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"版本更新", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (VersionUpdateHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"VersionUpdateHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 319.5);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (VersionUpdateTipView *)versionUpdateTipView{
    if (!_versionUpdateTipView) {
        _versionUpdateTipView = [[VersionUpdateTipView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _versionUpdateTipView.delegate = self;
    }
    return _versionUpdateTipView;
}

- (CommonDialogHasTitleView *)commonDialogHasTitleView{
    if (!_commonDialogHasTitleView) {
        _commonDialogHasTitleView = [[CommonDialogHasTitleView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
        _commonDialogHasTitleView.delegate = self;
    }
    return _commonDialogHasTitleView;
}



- (GetVersionInfoRequest *)getVersionInfoRequest{
    if (!_getVersionInfoRequest) {
        _getVersionInfoRequest = [[GetVersionInfoRequest alloc] init];
    }
    return _getVersionInfoRequest;
}
- (VersionUpdateModel *)versionUpdateModel{
    if (!_versionUpdateModel) {
        _versionUpdateModel = [[VersionUpdateModel alloc] init];
    }
    return _versionUpdateModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"版本更新"]; //("Pagename"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"版本更新"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    // 当前版本号
    NSDictionary *infoDic= [[NSBundle mainBundle] infoDictionary];
    self.headerView.versionLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"版本", nil), [infoDic valueForKey:@"CFBundleShortVersionString"]  ];
    [self buildDataSource];
    self.view.lee_theme
    .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
}

- (void)buildDataSource{
    WS(weakSelf);
    [self.getVersionInfoRequest getDataSusscess:^(id DAO, id data) {
        weakSelf.versionUpdateModel = [VersionUpdateModel mj_objectWithKeyValues:data[@"data"]];
        if (weakSelf.versionUpdateModel.versionCode.integerValue > [weakSelf queryVersionNumberInBundle] ) {
            weakSelf.headerView.tipLabel.text = NSLocalizedString(@"有新版・", nil);
            weakSelf.headerView.tipLabel.textColor = HEX_RGB(0xF21717);
        }else{
            weakSelf.headerView.tipLabel.text = NSLocalizedString(@"无新版", nil);
            weakSelf.headerView.tipLabel.textColor = HEX_RGB(0x999999);
        }
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)versionIntroduceBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.commonDialogHasTitleView];
    
    OptionModel *model = [[OptionModel alloc] init];
    model.optionName = NSLocalizedString(@"版本介绍", nil);
    model.detail = self.versionUpdateModel.versionDetail;
    [self.commonDialogHasTitleView setModel:model];
}

- (void)checkNewVersionBtnDidClick:(UIButton *)sender{
    if (self.versionUpdateModel.versionCode.integerValue > [self queryVersionNumberInBundle] ) {
        [self.view addSubview:self.versionUpdateTipView];
        [self.versionUpdateTipView setModel:self.versionUpdateModel];
    }else{
        
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//VersionUpdateTipViewDelegate
- (void)skipBtnDidClick:(UIButton *)sender{
    [self.versionUpdateTipView removeFromSuperview];
}

- (void)updateBtnDidClick:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://pocketeos.com"]];
}

//CommonDialogHasTitleViewDelegate
- (void)commonDialogHasTitleViewBtnDidClick:(UIButton *)sender{
    [self.commonDialogHasTitleView removeFromSuperview];
}


- (NSInteger)queryVersionNumberInBundle{
    
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    // 当前版本号
    NSString *currentVersionStr =  [infoDic valueForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return versionStr.integerValue;
}
@end
