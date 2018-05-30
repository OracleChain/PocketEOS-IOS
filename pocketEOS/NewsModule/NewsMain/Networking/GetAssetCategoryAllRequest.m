//
//  GetAssetCategoryAllRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetAssetCategoryAllRequest.h"

@implementation GetAssetCategoryAllRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/getAssetCategoryAll", REQUEST_PERSONAL_BASEURL];
}

@end
