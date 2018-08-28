
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
        .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.4));
        
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            self.placeholderColor = HEXCOLOR(0xDDDDDD);
            
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            self.placeholderColor = HEX_RGB_Alpha(0xFFFFFF, 0.4);

        }
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color")
    .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A))
    .LeeAddTextColor(BLACKBOX_MODE, RGBA(255, 255, 255, 0.4));
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.placeholderColor = HEXCOLOR(0xDDDDDD);
        
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.placeholderColor = HEX_RGB_Alpha(0xFFFFFF, 0.4);
        
    }
}
@end
