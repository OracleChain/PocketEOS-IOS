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

@interface VersionUpdateViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, VersionUpdateHeaderViewDelegate, VersionUpdateTipViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) VersionUpdateHeaderView *headerView;
@property(nonatomic , strong) VersionUpdateTipView *versionUpdateTipView;
@property(nonatomic , strong) GetVersionInfoRequest *getVersionInfoRequest;
@property(nonatomic , strong) VersionUpdateModel *versionUpdateModel;
@end

@implementation VersionUpdateViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"版本更新" rightBtnImgName:@"" delegate:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    // 当前版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    self.headerView.versionLabel.text = [NSString stringWithFormat:@"版本: %@", [infoDic valueForKey:@"CFBundleShortVersionString"]];
    [self buildDataSource];
    self.view.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
}

- (void)buildDataSource{
    WS(weakSelf);
    [self.getVersionInfoRequest getDataSusscess:^(id DAO, id data) {
        weakSelf.versionUpdateModel = [VersionUpdateModel mj_objectWithKeyValues:data[@"data"]];
        if (weakSelf.versionUpdateModel.versionCode.integerValue > [weakSelf queryVersionNumberInBundle] ) {
            weakSelf.headerView.tipLabel.text = @"有新版・";
            weakSelf.headerView.tipLabel.textColor = HEX_RGB(0xF21717);
        }else{
            weakSelf.headerView.tipLabel.text = @"无新版";
            weakSelf.headerView.tipLabel.textColor = HEX_RGB(0x999999);
        }
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)versionIntroduceBtnDidClick:(UIButton *)sender{
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
//    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/cn/app/coostay-%E6%B5%B7%E5%A4%96%E6%B7%B1%E5%BA%A6%E6%97%85%E5%B1%85%E6%96%B0%E5%85%B4%E5%AE%B6%E5%9B%AD/id1126818186?l=en&mt=8"]];
}

- (NSInteger)queryVersionNumberInBundle{
    
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    // 当前版本号
    NSString *currentVersionStr =  [infoDic valueForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return versionStr.integerValue;
}
@end
