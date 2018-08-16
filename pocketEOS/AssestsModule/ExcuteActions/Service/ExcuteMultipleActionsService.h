//
//  ExcuteMultipleActionsService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "ExcuteActions.h"
#import "TransactionResult.h"

@protocol ExcuteMultipleActionsServiceDelegate<NSObject>
- (void)excuteMultipleActionsDidFinish:(TransactionResult *)result;
@end



@interface ExcuteMultipleActionsService : BaseService

@property(nonatomic, weak) id<ExcuteMultipleActionsServiceDelegate> delegate;

// excuteMultipleActions
- (void)excuteMultipleActionsWithSender:(NSString *)sender andExcuteActionsArray:(NSArray <ExcuteActions *>*)excuteActionsArray andAvailable_keysArray:(NSArray *)available_keysArray andPassword:(NSString *)password;


@end
