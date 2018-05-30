//
//  ImportPocketViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/11.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ImportPocketViewController.h"
#import "NavigationView.h"
#import "ImportPocketHeaderView.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"


@interface ImportPocketViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, ImportPocketHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) ImportPocketHeaderView *importPocketHeaderView;
@end

@implementation ImportPocketViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"导入钱包" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (ImportPocketHeaderView *)importPocketHeaderView{
    if (!_importPocketHeaderView) {
        _importPocketHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ImportPocketHeaderView" owner:nil options:nil] firstObject];
        _importPocketHeaderView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 252);
        _importPocketHeaderView.delegate = self;
    }
    return _importPocketHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.importPocketHeaderView];
}

//ImportPocketViewDelegate
-(void)importPocketBtnDidClick:(UIButton *)sender{
    Wallet *model = [Wallet mj_objectWithKeyValues:[self.importPocketHeaderView.pocketTextView.text mj_JSONObject]];
    if ([[WalletTableManager walletTable] addRecord: model]) {
        
        [TOASTVIEW showWithText:@"导入成功!"];
        for (UIView *view in WINDOW.subviews) {
            [view removeFromSuperview];
        }
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
        
    }else{
        [TOASTVIEW showWithText:@"导入失败!"];
    }
    
    
}

//NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
