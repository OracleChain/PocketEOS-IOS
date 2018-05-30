//
//  PostFeedbackRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/29.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PostFeedbackRequest.h"

@implementation PostFeedbackRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/add_infoFeedback", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.uid) forKey:@"uid"];
    [params setObject:VALIDATE_STRING(self.content) forKey:@"content"];
    return [params clearEmptyObject];
}
@end
