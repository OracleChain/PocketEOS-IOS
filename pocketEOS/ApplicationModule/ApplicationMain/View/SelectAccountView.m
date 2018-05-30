//
//  SelectAccountView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SelectAccountView.h"

@interface SelectAccountView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@end


@implementation SelectAccountView


-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
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

- (IBAction)selectAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAccountBtnDidClick:)]) {
        [self.delegate selectAccountBtnDidClick:sender];
    }
}

- (IBAction)understand:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(understandBtnDidClick:)]) {
        [self.delegate understandBtnDidClick:sender];
    }
}

@end
