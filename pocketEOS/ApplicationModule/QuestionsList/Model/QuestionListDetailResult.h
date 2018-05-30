//
//  QuestionListDetailResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionListDetailResult : NSObject
@property(nonatomic, strong) NSNumber *currentPage;
@property(nonatomic, strong) NSNumber *rowsPerPage;
@property(nonatomic, strong) NSNumber *totalPages;
@property(nonatomic, strong) NSNumber *totalRows;
@property(nonatomic, strong) NSArray *data;
@end
