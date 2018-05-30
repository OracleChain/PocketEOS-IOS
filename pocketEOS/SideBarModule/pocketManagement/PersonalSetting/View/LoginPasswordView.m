//
//  LoginPasswordView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "LoginPasswordView.h"

@interface LoginPasswordView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;


@end


@implementation LoginPasswordView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
}

- (void)dismiss{
    [self removeFromSuperview];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.upBackgroundView]) {
        return NO;
        
    }else{
        return YES;
    }
}

- (IBAction)cancle:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleBtnDidClick:)]) {
        [self.delegate cancleBtnDidClick:sender];
    }
}

- (IBAction)confirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnDidClick:)]) {
        [self.delegate confirmBtnDidClick:sender];
    }
}

@end
