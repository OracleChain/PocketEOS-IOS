//
//  LoginView.m
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "LoginView.h"

@interface LoginView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *changeToBlackBoxModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;

@end

@implementation LoginView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismiss)];
//    tap.delegate = self;
//    [self.containView addGestureRecognizer:tap];
//    if ([DeviceType getIsIpad]) {
//        self.scrollHeight.constant = 150;
//    }
    self.scrollHeight.constant = 700;
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
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: NSLocalizedString(@"登录即代表同意《用户协议及隐私政策》", nil)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:
     HEXCOLOR(0x999999) range:NSMakeRange(0,attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attrStr.length)];
    
   
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(attrStr.length-10, 9)]; // 下划线
    [attrStr addAttribute:NSUnderlineColorAttributeName value:
     HEXCOLOR(0x999999) range:NSMakeRange(attrStr.length-10, 9)]; // 下划线颜色
    NSLog(@"%@", SWWAppCurrentLanguage);
    
    self.privacyPolicyLabel.attributedText = attrStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyPolicy)];
    self.privacyPolicyLabel.userInteractionEnabled = YES;
    [self.privacyPolicyLabel addGestureRecognizer:tap];
    
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

- (void)privacyPolicy{
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyLabelDidTap)]) {
        [self.delegate privacyPolicyLabelDidTap];
    }
}

- (IBAction)areaCodeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaCodeBtnDidClick)]) {
        [self.delegate areaCodeBtnDidClick];
    }
    
}

@end
