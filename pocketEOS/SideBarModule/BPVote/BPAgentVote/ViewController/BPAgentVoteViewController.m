//
//  BPAgentVoteViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPAgentVoteViewController.h"
#import "BPAgentVoteHeaderView.h"
#import "BPRecommendAgentViewController.h"

@interface BPAgentVoteViewController ()<BPAgentVoteHeaderViewDelegate, NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic , strong) BPAgentVoteHeaderView *headerView;
@end

@implementation BPAgentVoteViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"代理投票", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    }
    return _navView;
    
}

- (BPAgentVoteHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BPAgentVoteHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT);
        _headerView.delegate = self;
    }
    return _headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.headerView];
    self.view.backgroundColor = HEXCOLOR(0x000000);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self configBottomBtn];
}

// BPAgentVoteHeaderViewDelegate
-(void)confirmAgentBtnDidClick:(UIButton *)sender{
    [TOASTVIEW showWithText:@"confirmAgentBtnDidClick"];
    
}

- (void)chooseAgentBtnDidClick:(UIButton *)sender{
    BPRecommendAgentViewController *vc = [[BPRecommendAgentViewController alloc] init];
    [self.navigationController pushViewController: vc animated:YES];
}


- (void)configBottomBtn{
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:NSLocalizedString(@"什么是投票权代理?", nil)forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:HEX_RGB_Alpha(0xFFFFFF, 0.7) forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(explainBPVoteAgent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view, MARGIN_20).rightSpaceToView(self.view, MARGIN_20).bottomSpaceToView(self.view, 23).heightIs(21);
}

- (void)explainBPVoteAgent{
    [TOASTVIEW showWithText:NSLocalizedString(@"什么是投票权代理?", nil)];
}
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
