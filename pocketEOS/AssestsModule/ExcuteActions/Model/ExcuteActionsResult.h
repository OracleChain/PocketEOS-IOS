//
//  ExcuteActionsResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExcuteActionsResult : NSObject
@property(nonatomic , copy) NSString *type;
@property(nonatomic , strong) NSMutableArray *actions;
@end
