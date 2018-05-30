//
//  AskQuestionTipView.m
//  pocketEOS
//
//  Created by oraclechain on 29/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AskQuestionTipView.h"



@interface AskQuestionTipView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;

@end

@implementation AskQuestionTipView

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
    if (self.delegate && [self.delegate respondsToSelector:@selector(askQuestionTipViewCancleBtnDidClick:)]) {
        [self.delegate askQuestionTipViewCancleBtnDidClick:sender];
    }
}

- (IBAction)confirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(askQuestionTipViewConfirmBtnDidClick:)]) {
        [self.delegate askQuestionTipViewConfirmBtnDidClick:sender];
    }
}

@end
