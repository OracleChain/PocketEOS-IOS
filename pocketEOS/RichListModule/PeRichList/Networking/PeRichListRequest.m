//
//  PeRichListRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PeRichListRequest.h"

@implementation PeRichListRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/top/getPersonal", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_NUMBER(self.offset) forKey:@"offset"];
    [params setObject:VALIDATE_NUMBER(self.size) forKey:@"size"];
    
    return [params clearEmptyObject];
}
@end
