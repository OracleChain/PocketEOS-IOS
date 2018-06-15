//
//  BPCandidateDetailResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPCandidateDetailResult : NSObject
@property(nonatomic, strong) NSNumber *currentPage;
@property(nonatomic, strong) NSNumber *rowsPerPage;
@property(nonatomic, strong) NSNumber *totalPages;
@property(nonatomic, strong) NSNumber *totalRows;
@property(nonatomic, strong) NSArray *data;
@end
