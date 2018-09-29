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

@property(nonatomic , copy) NSString *dappName;
@property(nonatomic , copy) NSString *dappIcon;
@property(nonatomic , copy) NSString *serialNumber;
@property(nonatomic , copy) NSString *expired;
@property(nonatomic , copy) NSString *desc;
@property(nonatomic , copy) NSString *callback;
@property(nonatomic , copy) NSString *protocol;




@end
