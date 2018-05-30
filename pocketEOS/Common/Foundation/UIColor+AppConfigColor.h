//
//  UIColor+AppConfigColor.h
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/16.
//  Copyright © 2016 Youdar . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppConfigColor)
/**
 *  background color
 *
 *  @return UIColor
 */
+(UIColor *)viewBackgroundColor;

/**
 *  background  gray color
 *
 *  @return UIColor
 */
+(UIColor *)backgroundGrayColor;

/**
 *  theme color
 *
 *  @return UIColor
 */
+(UIColor *)themeColor;

/**
 *  app alpha white color
 *
 *  @return UIColor
 */
+(UIColor *)appAlphaWhiteColor;

/**
 *  app alpha yellow color
 *
 *  @return UIColor
 */
+(UIColor *)appYellowColor;

+(UIColor *)textOrangeColor;

/**
 *  app green color
 *
 *  @return UIColor
 */
+(UIColor *)appGreenColor;

/**
 *  app alpha yellow color
 *
 *  @return UIColor
 */
+(UIColor *)appGoldColor;

/**
 *  The default line gray color
 *
 *  @return UIColor
 */
+(UIColor *)lineGrayColor;

/**
 *  The default font white
 *
 *  @return UIColor
 */
+(UIColor *)textWhiteColor;

/**
 *  The default font Black
 *
 *  @return UIColor
 */
+(UIColor *)textBlackColor;

/**
 *  The default font light Black
 *
 *  @return UIColor
 */
+(UIColor *)textLightBlackColor;

/**
 *  The default font gray
 *
 *  @return UIColor
 */
+(UIColor *)textGrayColor;

/**
 *  The default font light gray
 *
 *  @return UIColor
 */
+(UIColor *)textLightGrayColor;

// 黑色, 0.3 alpha
+(UIColor *)textBlackColorWithAlpha3;
/**
 *  app blue color
 *
 *  @return UIColor
 */
+(UIColor *)appBlueColor;

+ (UIColor *)textGreenColor;
+ (UIColor *)textBlueColor;
@end
