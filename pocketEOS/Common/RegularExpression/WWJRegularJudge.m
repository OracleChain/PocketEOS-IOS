//
//  ZhengZeJudge.m
//  TouRongSu
//
//  Created by wwj on 14-7-17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "WWJRegularJudge.h"
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@implementation WWJRegularJudge

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((14[0-9])|(17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)validatePassword:(NSString *)password
{
    //6-20位
    if (password.length != 6) {
        return NO;
    }
    if(![self validateByRegex:@"^[0-9]{6}$" withObject:password]){
        return NO;
    }
    return YES;
}

+(BOOL)validatePaymentPassword:(NSString *)password{
    //6-20位
    if (password.length != 6) {
        return NO;
    }
    if(![self validateByRegex:@"^[0-9]{6}$" withObject:password]){
        return NO;
    }
    return YES;
}

+(BOOL)validateBankCardNumber:(NSString *)cardNumber{
    if(![self validateByRegex:@"^[0-9]*$" withObject:cardNumber]){
        
        
        
        return NO;
    }
    return YES;
}

+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)validateByRegex:(NSString *)regex withObject:(id)object
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES% @", regex];
    return [predicate evaluateWithObject:object];
}

+(BOOL)isMatchPasswordFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    if(![self validateByRegex:@"[0-9]+" withObject:string]){
        return NO;
    }
    if (textField.text.length >= 6) {
        return NO;
    }
    return YES;
}

// 手机号
+(BOOL)isMatchTelephoneFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    if(![self validateByRegex:@"[0-9]+" withObject:string]){
        return NO;
    }
    if (textField.text.length >= 11) {
        return NO;
    }
    return YES;
}

// 身份证号
+(BOOL)isMatchIdentityCardFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    if(![self validateByRegex:@"[0-9,xX]+" withObject:string]){
        return NO;
    }
    if (textField.text.length >= 18) {
        return NO;
    }
    return YES;
}


// 短信验证码
+(BOOL)isMatchShortMessageFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    if(![self validateByRegex:@"[0-9]+" withObject:string]){
        return NO;
    }
    if (textField.text.length >= 6) {
        return NO;
    }
    return YES;
}


+(BOOL)isMatchBankCardNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    if(![self validateByRegex:@"[0-9]+" withObject:string]){
        return NO;
    }
    if (textField.text.length >= 19) {
        return NO;
    }
    return YES;
    
}



+(BOOL)isMatchMoneyFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
//        if (textField.text.length>=20) {  //小数点前面7位
//            return NO;
//        }
    }else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
        if (textField.text.length>=23) {
            return  NO;
        }
    }
    if([textField.text isEqualToString:@"."]){
        return NO;
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {//小数点后面两位
        return NO;
    }
    return YES;
    
}

+ (BOOL)isValidateMerRate:(NSString *)merRate
{
    NSString *emailCheck = @"^[0-9]{0,7}+([.]{0,1}[0-9]{0,1}+){0,1}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:merRate];
}


@end
