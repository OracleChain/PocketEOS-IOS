//
//  WalletQRCodeView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "WalletQRCodeView.h"
#import "SocialSharePanelView.h"
#import "SocialShareModel.h"


@interface WalletQRCodeView()<UIGestureRecognizerDelegate, SocialSharePanelViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *socialSharePanelBackgroundView;
@property(nonatomic , strong) SocialSharePanelView *socialSharePanelView;
@property(nonatomic , strong) NSArray *platformNameArr;
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;

@end


@implementation WalletQRCodeView

- (SocialSharePanelView *)socialSharePanelView{
    if (!_socialSharePanelView) {
        _socialSharePanelView = [[SocialSharePanelView alloc] init];
        _socialSharePanelView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _socialSharePanelView.delegate = self;
        NSMutableArray *modelArr = [NSMutableArray array];
        NSArray *titleArr = @[@"微信好友",@"朋友圈", @"QQ好友", @"QQ空间"];
        for (int i = 0; i < 4; i++) {
            SocialShareModel *model = [[SocialShareModel alloc] init];
            model.platformName = titleArr[i];
            model.platformImage = self.platformNameArr[i];
            [modelArr addObject:model];
        }
        self.socialSharePanelView.labelTopSpace = 11.5;
        self.socialSharePanelView.frame = self.socialSharePanelBackgroundView.bounds;
        [_socialSharePanelView updateViewWithArray:modelArr];
    }
    return _socialSharePanelView;
}
- (NSArray *)platformNameArr{
    if (!_platformNameArr) {
        _platformNameArr = @[@"wechat_friends",@"wechat_moments", @"qq_friends", @"qq_Zone"];
    }
    return _platformNameArr;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    [self.socialSharePanelBackgroundView addSubview:self.socialSharePanelView];
}


// SocialSharePanelViewDelegate
- (void)SocialSharePanelViewDidTap:(UITapGestureRecognizer *)sender{
    NSString *platformName = self.platformNameArr[sender.view.tag-1000];
    NSLog(@"%@", platformName);
    
    if ([platformName isEqualToString:@"wechat_friends"]) {
        [[SocialManager socialManager] wechatShareImageToScene:0 withImage:[UIImage convertViewToImage:self.upBackgroundView]];
    }else if ([platformName isEqualToString:@"wechat_moments"]){
        [[SocialManager socialManager] wechatShareImageToScene:1 withImage:[UIImage convertViewToImage:self.upBackgroundView]];
    }else if ([platformName isEqualToString:@"qq_friends"]){
        [[SocialManager socialManager] qqShareToScene:0 withShareImage:[UIImage convertViewToImage:self.upBackgroundView]];
    }else if ([platformName isEqualToString:@"qq_Zone"]){
        [[SocialManager socialManager] qqShareToScene:1 withShareImage:[UIImage convertViewToImage:self.upBackgroundView]];
    }
}


- (void)dismiss{
    [self removeFromSuperview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.contentBackgroundView] || [touch.view isEqual:self.socialSharePanelBackgroundView]) {
        return NO;
    }else{
        return YES;
    }
}

@end
