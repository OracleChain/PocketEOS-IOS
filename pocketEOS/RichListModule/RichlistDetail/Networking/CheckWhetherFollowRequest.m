//
//  CheckWhetherFollowRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CheckWhetherFollowRequest.h"

@implementation CheckWhetherFollowRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/isFollowRecord", REQUEST_PERSONAL_BASEURL];
}
-(id)parameters{
    return @{
             @"fuid" : VALIDATE_STRING(self.fuid),
             @"followType" : VALIDATE_NUMBER(self.followType),
             @"uid" : VALIDATE_STRING(self.uid),
             @"followTarget" : VALIDATE_STRING(self.followTarget),
             
             };
}
@end
