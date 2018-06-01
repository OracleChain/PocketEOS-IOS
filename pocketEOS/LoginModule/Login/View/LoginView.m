//
//  LoginView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "LoginView.h"

@interface LoginView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *changeToBlackBoxModeLabel;


@end

@implementation LoginView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismiss)];
//    tap.delegate = self;
//    [self.containView addGestureRecognizer:tap];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.colors = @[(__bridge id)HEXCOLOR(0x3083ff).CGColor, (__bridge id)HEXCOLOR(0x1566df).CGColor];
    layer.locations = @[@(0.5f), @(1.0f)];
    [self.upBackgroundView.layer addSublayer:layer];
    
    [self.upBackgroundView bringSubviewToFront:self.label1];
    [self.upBackgroundView bringSubviewToFront:self.label2];
    [self.upBackgroundView bringSubviewToFront:self.img];
    [self.upBackgroundView bringSubviewToFront:self.rightArrowImg];
    [self.upBackgroundView bringSubviewToFront:self.changeToBlackBoxModeLabel];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
        // Fallback on earlier versions
    }
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeToBlackBoxMode)];
    [self.changeToBlackBoxModeLabel addGestureRecognizer:tap1];

}

- (void)changeToBlackBoxMode{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeToBlackBoxMode)]) {
        [self.delegate changeToBlackBoxMode];
    }
}

- (IBAction)getVerifyCodeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyBtnDidClick:)]) {
        [self.delegate getVerifyBtnDidClick:sender];
    }
}

- (IBAction)loginBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginBtnDidClick:)]) {
        [self.delegate loginBtnDidClick:sender];
    }
}

- (IBAction)wechatLoginBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wechatLoginBtnDidClick:)]) {
        [self.delegate wechatLoginBtnDidClick:sender];
    }
}

- (IBAction)qqLoginBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(qqLoginBtnDidClick:)]) {
        [self.delegate qqLoginBtnDidClick:sender];
    }
}

- (void)shouldDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

- (IBAction)privacyPolicy:(BaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyBtnDidClick:)]) {
        [self.delegate privacyPolicyBtnDidClick:sender];
    }
}
- (IBAction)agreeBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

@end
