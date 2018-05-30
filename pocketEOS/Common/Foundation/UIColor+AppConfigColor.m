//
//  UIColor+AppConfigColor.m
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/16.
//  Copyright © 2016 Youdar . All rights reserved.
//

#import "UIColor+AppConfigColor.h"

@implementation UIColor (AppConfigColor)

#pragma mark - The default view background
+(UIColor *)viewBackgroundColor{
    return HEX_RGB(0xf5f6f7);
}

+(UIColor *)backgroundGrayColor{
//    return HEX_RGB(0xe6e6e6);
    return RGB(240, 241, 241);
}

#pragma mark - app blue color
+(UIColor *)appBlueColor{
    return RGB(27, 191, 247);
//    return HEX_RGB(0x46c9f7);
}

#pragma mark - app yellow color
+(UIColor *)appYellowColor{
    return HEX_RGB(0xf88d38);
}

#pragma mark - app green color
#warning -- 先将绿色改为蓝色, 以后再改回来
+(UIColor *)appGreenColor{
//    return RGB(0, 221, 140);
    return HEX_RGB(0x46c9f7);
}

#pragma mark - app green color
+(UIColor *)appGoldColor{
    return HEX_RGB(0xece000);
}

#pragma mark - app alpha white color
+(UIColor *)appAlphaWhiteColor{
    return [[UIColor alloc] initWithWhite: 1.0 alpha: 0.2f];
}

#pragma mark - theme color
+(UIColor *)themeColor{
    return HEX_RGB(0x00d79d);
}

#pragma mark - The default font black
+(UIColor *)textBlackColor{
    return HEX_RGB(0x4f5051);
}

#pragma mark - The default font light black
+(UIColor *)textLightBlackColor{
    return HEX_RGB(0x686868);
}

#pragma mark - The default font gray
+(UIColor *)textGrayColor{
    return HEX_RGB(0xa9a9a9);
    
    
}
// 黑色, 0.3 alpha
+(UIColor *)textBlackColorWithAlpha3{
    return RGBA(0, 0, 0, 0.3);
    
}


+(UIColor *)textOrangeColor{
    return HEX_RGB(0xff9c00);
}


#pragma mark - The default font light gray
+(UIColor *)textLightGrayColor{
    return HEX_RGB(0xafb0b1);
}

#pragma mark - 白色字体
+(UIColor *)textWhiteColor{
    return [[UIColor alloc] initWithWhite: 1.0f alpha: 0.9f];
}
#warning -- 先将绿色改为蓝色, 以后再改回来
+ (UIColor *)textGreenColor{
//    return RGB(0, 221, 140);
    return RGB(71, 201, 246);
}

+ (UIColor *)textBlueColor{
    return RGB(71, 201, 246);
}

#pragma mark - The default line gray color
+(UIColor *)lineGrayColor{
    return HEX_RGB(0xE0E0E0);
}

@end
