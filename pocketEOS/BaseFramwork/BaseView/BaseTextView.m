
//
//  BaseTextView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTextView.h"

@implementation BaseTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
    self.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color")
        .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
        .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.6));
        
        if ([[LEETheme currentThemeTag] isEqualToString:SOCIAL_MODE]) {
            self.placeholderColor = HEXCOLOR(0xD9D9D9);
            
        }else if ([[LEETheme currentThemeTag] isEqualToString:BLACKBOX_MODE]){
            self.placeholderColor = HEX_RGB_Alpha(0xFFFFFF, 0.6);

        }
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color")
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.6));
    
    if ([[LEETheme currentThemeTag] isEqualToString:SOCIAL_MODE]) {
        self.placeholderColor = HEXCOLOR(0xD9D9D9);
        
    }else if ([[LEETheme currentThemeTag] isEqualToString:BLACKBOX_MODE]){
        self.placeholderColor = HEX_RGB_Alpha(0xFFFFFF, 0.6);
        
    }
}
@end
