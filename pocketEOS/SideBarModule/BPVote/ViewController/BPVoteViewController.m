//
//  BPVoteViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPVoteViewController.h"
#import "NavigationView.h"

@interface BPVoteViewController ()<NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation BPVoteViewController


- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"节点投票" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    if ([[LEETheme currentThemeTag] isEqualToString:SOCIAL_MODE]) {
        [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithImageName:@"vote_box" andTitleStr:@"投票功能将在EOS主网上线开启，敬请关注" toView:self.view andViewController:self];
    }else if ([[LEETheme currentThemeTag] isEqualToString:BLACKBOX_MODE]){
        [IMAGE_TIP_LABEL_MANAGER showImageAddTipLabelViewWithImageName:@"vote_box_BB" andTitleStr:@"投票功能将在EOS主网上线开启，敬请关注" toView:self.view andViewController:self];
        
    }
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
