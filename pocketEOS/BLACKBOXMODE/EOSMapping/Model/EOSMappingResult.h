//
//  EOSMappingResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSMappingResult : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSArray *account_names;

@end
