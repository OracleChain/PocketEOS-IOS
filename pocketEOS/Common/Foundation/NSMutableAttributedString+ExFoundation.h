//
//  NSMutableAttributedString+ExFoundation.h
//  CooStaY
//
//  Created by Xiong,Zijun on 16/7/31.
//  Copyright © 2016年 Youdar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ExFoundation)

+ (NSMutableAttributedString *)lineSpace:(CGFloat) space text:(NSString *) text color:(UIColor *) color font:(UIFont *) font;
@end
