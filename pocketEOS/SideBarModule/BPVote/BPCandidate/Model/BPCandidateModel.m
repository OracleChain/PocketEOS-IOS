//
//  BPCandidateModel.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateModel.h"


@implementation BPCandidateModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"logo_256" : @"producerUrlInfo.org.branding.logo_256"};
}
@end
