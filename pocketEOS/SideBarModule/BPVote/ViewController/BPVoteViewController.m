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
@property(nonatomic , strong) UIImageView *img;
@property(nonatomic , strong) BaseLabel1 *tipLabel;

@end

@implementation BPVoteViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"节点投票" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
    
}

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _img;
}
- (BaseLabel1 *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[BaseLabel1 alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    
    self.img.lee_theme
    .LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"vote_box"])
    .LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"vote_box_BB"]);
    self.tipLabel.text = @"投票功能将在EOS主网上线开启，敬请关注";
    
    [self.view addSubview:self.img];
    [self.view addSubview:self.tipLabel];
    self.img.sd_layout.centerYIs(SCREEN_HEIGHT/2).centerXEqualToView(self.view).widthIs(140).heightIs(177);
    
    self.tipLabel.sd_layout.topSpaceToView(self.img, 34).centerXEqualToView(self.view).widthIs(SCREEN_WIDTH).heightIs(14);
   
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
