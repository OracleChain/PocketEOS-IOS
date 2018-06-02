//
//  BaseTextField.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.lee_theme
        .LeeConfigBackgroundColor(@"baseView_background_color")
        .LeeConfigTextColor(@"common_font_color_1")
        .LeeAddPlaceholderColor(SOCIAL_MODE, HEXCOLOR(0xDDDDDD))
        .LeeAddPlaceholderColor(BLACKBOX_MODE, RGBACOLOR(255, 255, 255, 0.4));
        self.font =  [UIFont boldSystemFontOfSize:15.0f];
        
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme
    .LeeConfigBackgroundColor(@"baseView_background_color")
    .LeeConfigTextColor(@"common_font_color_1")
    .LeeAddPlaceholderColor(SOCIAL_MODE, HEXCOLOR(0xDDDDDD))
    .LeeAddPlaceholderColor(BLACKBOX_MODE, RGBACOLOR(255, 255, 255, 0.4));
    self.font =  [UIFont boldSystemFontOfSize:15.0f];
    

}

@end
