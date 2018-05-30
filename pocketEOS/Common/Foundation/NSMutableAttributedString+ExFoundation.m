////
////  NSMutableAttributedString+ExFoundation.m
////  CooStaY
////
////  Created by Xiong,Zijun on 16/7/31.
////  Copyright © 2016年 Youdar. All rights reserved.
////
//
//#import "NSMutableAttributedString+ExFoundation.h"
//
//@implementation NSMutableAttributedString (ExFoundation)
//
//+ (NSMutableAttributedString *)lineSpace:(CGFloat) space text:(NSString *) text color:(UIColor *) color font:(UIFont *) font{
//    
//    NSMutableAttributedString *attributte = [[NSMutableAttributedString alloc] initWithString: text];
//    
//    [attributte addAttribute: NSForegroundColorAttributeName value: color range: NSMakeRange(0, attributte.length)];
//    [attributte addAttribute: NSFontAttributeName value: font range: NSMakeRange(0, attributte.length)];
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing: space];
//    [attributte addAttribute: NSParagraphStyleAttributeName value: paragraphStyle range: NSMakeRange(0, attributte.length)];
//    
//    return attributte;
//}
//@end

