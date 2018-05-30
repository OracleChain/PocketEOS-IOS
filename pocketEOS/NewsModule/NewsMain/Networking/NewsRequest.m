//
//  NewsRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "NewsRequest.h"

@implementation NewsRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/news_list", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_NUMBER(self.offset) forKey:@"offset"];
    [params setObject:VALIDATE_NUMBER(self.size) forKey:@"size"];
    [params setObject:VALIDATE_NUMBER(self.assetCategoryId) forKey:@"assetCategoryId"];
    [params setObject:VALIDATE_NUMBER(self.scope) forKey:@"scope"];
    
    return [params clearEmptyObject];
}

@end
