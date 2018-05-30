//
//  PersonnalSettingDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PersonnalSettingDetailViewController.h"
#import "PersonalSettingService.h"
#import "PersonalSettingDetailHeaderView.h"
#import "NavigationView.h"

@interface PersonnalSettingDetailViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate>
@property(nonatomic, strong) PersonalSettingService *mainService;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) PersonalSettingDetailHeaderView *headerView;
@end

@implementation PersonnalSettingDetailViewController

- (PersonalSettingService *)mainService{
    if (!_mainService) {
        _mainService = [[PersonalSettingService alloc] init];
    }
    return _mainService;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:VALIDATE_STRING(self.titleStr) rightBtnTitleName:@"保存" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (PersonalSettingDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"PersonalSettingDetailHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 62);
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.headerView.itemNameLabel.text = self.itemName;
}

// NavigationViewDelegate
- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    WS(weakSelf);
    if ([self.titleStr isEqualToString:@"名字"]) {
        // 设置钱包名字
        self.mainService.updateUserNameRequest.userName = self.headerView.itemTF.text;
        [self.mainService.updateUserNameRequest postDataSuccess:^(id DAO, id data) {
            NSNumber *code = data[@"code"];
            if ([code isEqualToNumber:@0]) {
                [[WalletTableManager walletTable] executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET wallet_name = '%@' WHERE wallet_uid = '%@'", WALLET_TABLE , weakSelf.headerView.itemTF.text , CURRENT_WALLET_UID]];
            }
            [TOASTVIEW showWithText:VALIDATE_STRING(data[@"message"])];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(id DAO, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}


@end
