//
//  EOSMappingImportAccountViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSMappingImportAccountViewController.h"
#import "EOSMappingImportAccountHeaderView.h"
#import "NavigationView.h"
#import "GetAccountRequest.h"
#import "GetAccountResult.h"
#import "GetAccount.h"
#import "Permission.h"

@interface EOSMappingImportAccountViewController ()<UIGestureRecognizerDelegate, NavigationViewDelegate, EOSMappingImportAccountHeaderViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) EOSMappingImportAccountHeaderView *headerView;

@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@end

@implementation EOSMappingImportAccountViewController
{   // 从网络获取的公钥
    NSString *active_public_key_from_network;
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *active_public_key_from_local;
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
    BOOL private_active_Key_is_validate;
}
- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"映射账号录入" rightBtnTitleName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (EOSMappingImportAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EOSMappingImportAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 230);
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
}

- (void)importEOSMappingAccountBtnDidClick{
    [TOASTVIEW showWithText:@"EOS主网上线之后，该功能开放!"];
    // 请求该账号的公钥
//    WS(weakSelf);
//    self.getAccountRequest.name = VALIDATE_STRING(self.headerView.accountNameTF.text) ;
//    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
//        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
//        if (![result.code isEqualToNumber:@0]) {
//            [TOASTVIEW showWithText: result.message];
//        }else{
//            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
//
//            for (Permission *permission in model.permissions) {
//                if ([permission.perm_name isEqualToString:@"active"]) {
//                    active_public_key_from_network = permission.required_auth_key;
//                }else if ([permission.perm_name isEqualToString:@"owner"]){
//                    owner_public_key_from_network = permission.required_auth_key;
//                }
//            }
//            if ([active_public_key_from_network isEqualToString: active_public_key_from_local] && [owner_public_key_from_network isEqualToString:owner_public_key_from_local]) {
//                // 本地公钥和网络公钥匹配, 允许进行导入本地操作
//                AccountInfo *accountInfo = [[AccountInfo alloc] init];
//                accountInfo.account_name = weakSelf.headerView.accountNameTF.text;
//                accountInfo.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
//                accountInfo.account_owner_public_key = owner_public_key_from_local;
//                accountInfo.account_active_public_key = active_public_key_from_local;
//
//                accountInfo.is_privacy_policy = @"0";
//                [[AccountsTableManager accountTable] addRecord:accountInfo];
//                [TOASTVIEW showWithText:@"导入账号成功!"];
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            }else{
//                [TOASTVIEW showWithText:@"导入的私钥不匹配!"];
//            }
//        }
//    } failure:^(id DAO, NSError *error) {
//        NSLog(@"%@", error);
//    }];
}

//  NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
