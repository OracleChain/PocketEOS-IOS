//
//  PaymentTipView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "PaymentTipView.h"

@interface PaymentTipView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayRightIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatPayRightIconImageView;
@property(nonatomic , strong) NSMutableArray *allRightIconImageViewArray;
@end


@implementation PaymentTipView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.allRightIconImageViewArray = [NSMutableArray arrayWithObjects:self.alipayRightIconImageView, self.wechatPayRightIconImageView, nil];
   
}

- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backgroundViewDidClick)]) {
        [self.delegate backgroundViewDidClick];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.backgroundView]) {
        return NO;
        
    }else{
        return YES;
    }
}


/**
 sender.tag = 1000 alipay
 sender.tag = 1001 wechatPay
 */
- (IBAction)choosePaymentBtn:(UIButton *)sender {
    for (UIImageView *img in self.allRightIconImageViewArray) {
        if (img.tag == sender.tag) {
            img.image = [UIImage imageNamed:@"select__BB_wallet_icon"];
        }else{
            img.image = [UIImage imageNamed:@"unSelect__BB_wallet_icon"];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePaymentBtnDidClick:)]) {
        [self.delegate choosePaymentBtnDidClick:sender];
    }
}


- (IBAction)confirmPayBtn:(BaseConfirmButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmPayBtnDidClick:)]) {
        [self.delegate confirmPayBtnDidClick:sender];
    }
}
@end
