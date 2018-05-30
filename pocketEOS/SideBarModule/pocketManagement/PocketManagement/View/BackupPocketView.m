//
//  BackupPocketView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BackupPocketView.h"

@interface BackupPocketView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end

@implementation BackupPocketView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImg:)];
    tap1.delegate = self;
    [self.iconImg addGestureRecognizer:tap1];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)iconImg:(UIGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconImgDidTap:)]) {
        [self.delegate iconImgDidTap:sender];
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.upBackgroundView]) {
        return NO;
        
    }else{
        return YES;
    }
}



@end
