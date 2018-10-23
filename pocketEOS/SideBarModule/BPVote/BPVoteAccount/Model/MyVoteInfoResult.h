//
//  MyVoteInfoResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyVoteInfo;
@class MyVoteProducers;

@interface MyVoteInfoResult : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic , strong) MyVoteInfo *info;
@property(nonatomic , strong) NSMutableArray *producers;
@end
