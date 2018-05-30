//
//  BaseSlimLineView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/23.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseSlimLineView.h"

@implementation BaseSlimLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xEEEEEE)).LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xEEEEEE)).LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.1));
}


@end
