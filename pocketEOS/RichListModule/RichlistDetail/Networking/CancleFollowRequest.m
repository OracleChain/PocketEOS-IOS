//
//  CancleFollowRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CancleFollowRequest.h"

@implementation CancleFollowRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/cancel_follow", REQUEST_PERSONAL_BASEURL];
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
