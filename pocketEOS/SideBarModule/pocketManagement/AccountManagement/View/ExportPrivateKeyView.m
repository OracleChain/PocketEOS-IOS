//
//  ExportPrivateKeyView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ExportPrivateKeyView.h"


@interface ExportPrivateKeyView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *generateQRCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateKeyCopyBtn;


@end

@implementation ExportPrivateKeyView

- (UIImageView *)QRCodeimg{
    if (!_QRCodeimg) {
        _QRCodeimg = [[UIImageView alloc] init];
    }
    return _QRCodeimg;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self.upBackgroundView addSubview:self.QRCodeimg];
    CGFloat itemWidth = 90;
    self.QRCodeimg.frame = CGRectMake((290/2) - (itemWidth / 2), 47 + 20 , itemWidth, itemWidth);

    
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

- (IBAction)generateQRCodeBtn:(UIButton *)sender {
    self.contentTextView.hidden = YES;
    self.QRCodeimg.hidden = NO;
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(genetateQRBtnDidClick:)]) {
        [self.delegate genetateQRBtnDidClick:sender];
    }
}

- (IBAction)copyBtn:(UIButton *)sender {
    self.QRCodeimg.hidden = YES;
    self.contentTextView.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyBtnDidClick:)]) {
        [self.delegate copyBtnDidClick:sender];
    }
}


@end
