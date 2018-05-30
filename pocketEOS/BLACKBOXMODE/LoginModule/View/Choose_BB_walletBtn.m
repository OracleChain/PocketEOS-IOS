//
//  CustomBtn.m
//  wwwwwww
//
//  Created by oraclechain on 2018/5/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Choose_BB_walletBtn.h"

@implementation Choose_BB_walletBtn

- (void)layoutSubviews
{    [super layoutSubviews];
    CGFloat imageHeight = 17 ;
    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(imageHeight, imageHeight);
    imageRect.origin.x = 0 ;
    imageRect.origin.y = 0;
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = 31;
    titleRect.origin.y = 0;
    self.imageView.frame = imageRect;    self.titleLabel.frame = titleRect;
    
}


@end
