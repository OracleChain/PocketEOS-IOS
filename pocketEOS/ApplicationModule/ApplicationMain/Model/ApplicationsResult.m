//
//  ApplicationsResult.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ApplicationsResult.h"

@implementation ApplicationsResult
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : @"Application" 
             };
}
@end
