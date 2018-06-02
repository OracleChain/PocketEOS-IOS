//
//  BBLoginHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BBLoginHeaderView.h"

@interface BBLoginHeaderView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImg;
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *changeModeLabel;


@end


@implementation BBLoginHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
//    layer.startPoint = CGPointMake(0, 0);
//    layer.endPoint = CGPointMake(1, 0);
//    layer.colors = @[(__bridge id)HEXCOLOR(0x1F2532).CGColor, (__bridge id)HEXCOLOR(0x0E0F1A).CGColor];
//    layer.locations = @[@(0.0f), @(1.0f)];
//    [self.upBackgroundView.layer addSublayer:layer];
//    
//    [self.upBackgroundView bringSubviewToFront:self.changeModeLabel];
//    [self.upBackgroundView bringSubviewToFront:self.rightArrowImg];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeModeToSocialMode)];
    [self.changeModeLabel addGestureRecognizer:tap1];
}

- (void)changeModeToSocialMode{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeModeToSocialMode)]) {
        [self.delegate changeModeToSocialMode];
    }
}

@end
