//
//  MyVoteInfoResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "MyVoteInfoResult.h"

@implementation MyVoteInfoResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"info" : @"data.info",
             @"producers" : @"data.producers",
             };
}
@end
