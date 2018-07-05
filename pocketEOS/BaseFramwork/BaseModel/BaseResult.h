//
//  BaseResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResult : NSObject
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *message;
@end
