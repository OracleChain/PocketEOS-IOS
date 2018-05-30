//
//  GetFeedbackListRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetFeedbackListRequest.h"

@implementation GetFeedbackListRequest

-(NSString *)requestUrlPath{
     return [NSString stringWithFormat:@"%@/user/get_infoFeedback", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_NUMBER(self.offset) forKey:@"offset"];
    [params setObject:VALIDATE_NUMBER(self.size) forKey:@"size"];
    return [params clearEmptyObject];
}


@end
