//
//  UIColor+SNFoundation.h
//  SNFoundation
//
//  Created by Xiong, Zijun on 16/4/10.
//  Copyright (c) 2014 Youdar. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Color to create
 */
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor colorWithRGBHex:V]
#define HEX_RGB_Alpha(hex,a) [UIColor colorWithRGBHex:hex alpha:a]

@interface UIColor (SNFoundation)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithRGBHex:(UInt32) hex alpha:(CGFloat) alpha;
@end
