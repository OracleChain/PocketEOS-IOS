//
//  Get_pocketeos_info_Result.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_pocketeos_info_Result.h"

@implementation Get_pocketeos_info_Result

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"weChatOfficialAccount":@"data.weChatOfficialAccount",
             @"weChat":@"data.weChat",
             @"officialWebsite":@"data.officialWebsite",
             @"companyProfile":@"data.companyProfile"
             };
}

@end
