//
//  SetAppLanguageHelper.h
//  pocketEOS
//
//  Created by oraclechain on 12/29/16.
//  Copyright © 2016 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Language_Chinese         @"zh-Hant"
#define Language_English       @"en"

#define SWWAppCurrentLanguage [[SetAppLanguageHelper standardHelper] currentLanguage]
#define SWWLocalizedString(key, nil) [[SetAppLanguageHelper standardHelper] stringWithKey:key]

#define SWWAppCurrentLanguageIsChinese [[[SetAppLanguageHelper standardHelper]  currentLanguage]isEqualToString:Language_Chinese]
#define SWWAppCurrentLanguageIsEnglish [[[SetAppLanguageHelper standardHelper]  currentLanguage]isEqualToString:Language_English]

@interface SetAppLanguageHelper : NSObject


+ (instancetype)standardHelper;

- (NSBundle *)bundle;

- (NSString *)currentLanguage;

- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;

@end

