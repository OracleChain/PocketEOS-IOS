//
//  SWWButton.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/14.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "SWWButton.h"

@implementation SWWButton


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.80;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = CGRectGetWidth(contentRect) * 0.6;
    CGFloat imageH = contentRect.size.height * 0.6;
    CGFloat margin_X = CGRectGetWidth(contentRect) * (1- 0.6) / 2;
    return CGRectMake(margin_X, 0, imageW, imageH);
}

@end
