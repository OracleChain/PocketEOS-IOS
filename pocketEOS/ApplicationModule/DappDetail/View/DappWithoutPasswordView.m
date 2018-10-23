//
//  DappWithoutPasswordView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DappWithoutPasswordView.h"

@interface DappWithoutPasswordView ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;

@end

@implementation DappWithoutPasswordView

-(void)awakeFromNib{
    [super awakeFromNib];
     self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.tipTextView.text = NSLocalizedString(@"1. 使用免密功能将通过本地缓存为您自动填充密码；\n 2. 退出Dapp后免密功能自动失效，下次需要重新开启；\n 3. PE不会保存您的密码。\n", nil);
}

- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dappWithoutPasswordViewBackgroundViewDidClick)]) {
        [self.delegate dappWithoutPasswordViewBackgroundViewDidClick];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.backgroundView]) {
        return NO;
        
    }else{
        return YES;
    }
}

- (IBAction)dappWithoutPasswordViewConfirmBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dappWithoutPasswordViewConfirmBtnDidClick)]) {
        [self.delegate dappWithoutPasswordViewConfirmBtnDidClick];
    }
}
- (IBAction)dappWithoutPasswordViewCancleBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dappWithoutPasswordViewCancleDidClick)]) {
        [self.delegate dappWithoutPasswordViewCancleDidClick];
    }
}


- (IBAction)savePasswordBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

@end
