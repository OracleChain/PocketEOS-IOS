//
//  ModifyApproveViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ModifyApproveViewController.h"
#import "ModifyApproveHeaderView.h"
#import "UnstakeEosAbiJsonTobinRequest.h"
#import "ApproveToVoteSystem_Abi_json_to_bin_request.h"
#import "TransferService.h"


@interface ModifyApproveViewController ()<UINavigationControllerDelegate, LoginPasswordViewDelegate, ModifyApproveHeaderViewDelegate, TransferServiceDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) ModifyApproveHeaderView *headerView;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic , strong) UnstakeEosAbiJsonTobinRequest *unstakeEosAbiJsonTobinRequest;
@property(nonatomic , strong) ApproveToVoteSystem_Abi_json_to_bin_request *approveToVoteSystem_Abi_json_to_bin_request;

@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@end

@implementation ModifyApproveViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:NSLocalizedString(@"修改抵押额度", nil)rightBtnTitleName: nil delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.delegate = self;
    }
    return _navView;
}


- (ModifyApproveHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ModifyApproveHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 265);
    }
    return _headerView;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

- (UnstakeEosAbiJsonTobinRequest *)unstakeEosAbiJsonTobinRequest{
    if (!_unstakeEosAbiJsonTobinRequest) {
        _unstakeEosAbiJsonTobinRequest = [[UnstakeEosAbiJsonTobinRequest alloc] init];
    }
    return _unstakeEosAbiJsonTobinRequest;
}

- (ApproveToVoteSystem_Abi_json_to_bin_request *)approveToVoteSystem_Abi_json_to_bin_request{
    if (!_approveToVoteSystem_Abi_json_to_bin_request) {
        _approveToVoteSystem_Abi_json_to_bin_request = [[ApproveToVoteSystem_Abi_json_to_bin_request alloc] init];
    }
    return _approveToVoteSystem_Abi_json_to_bin_request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.headerView.model = self.eosResourceResult;
    self.view.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    
}

// ModifyApproveHeaderViewDelegate
- (void)confirmModifyBtnDidClick:(UIButton *)sender{
    [self.view addSubview:self.loginPasswordView];
}

// loginPasswordViewDelegate
- (void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

- (void)confirmBtnDidClick:(UIButton *)sender{
    
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    
    if (self.eosResourceResult.data.cpu_weight.doubleValue > 1 &&  self.eosResourceResult.data.net_weight.doubleValue > 1) {
        
        [self modifyApprove];
        if ([self.pageType isEqualToString: NSLocalizedString(@"cpu_bandwidth", nil)]) {
            //
            
        }else if ([self.pageType isEqualToString: NSLocalizedString(@"net_bandwidth", nil)]){
            
        }
    }else{
        [TOASTVIEW showWithText:@"无法赎回!"];
        [self.loginPasswordView removeFromSuperview];
        return;
    }
}


- (void)modifyApprove{
    
}

- (void)pushTransactionDidFinish:(EOSResourceResult *)result{
    if ([result.code isEqualToNumber:@0]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"赎回成功!", nil)];
        [self.navigationController popViewControllerAnimated: YES];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
    [self.loginPasswordView removeFromSuperview];
}


- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
@end
