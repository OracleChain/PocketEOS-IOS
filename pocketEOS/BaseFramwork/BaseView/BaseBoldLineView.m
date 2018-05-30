//
//  BaseBoldLineView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/23.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseBoldLineView.h"

@implementation BaseBoldLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF9F9F9)).LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0x0E0F1A, 0.8));
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF9F9F9)).LeeAddBackgroundColor(BLACKBOX_MODE, HEX_RGB_Alpha(0x0E0F1A, 0.8));
}

@end
