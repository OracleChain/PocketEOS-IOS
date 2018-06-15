//
//  BPCandidateResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/11.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPCandidateDetailResult;
@interface BPCandidateResult : NSObject
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) BPCandidateDetailResult *data;
@end
