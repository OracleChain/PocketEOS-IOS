//
//  CommonTransferModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTransferModel : NSObject

@property(nonatomic , copy) NSString *from;
@property(nonatomic , copy) NSString *to;
@property(nonatomic , copy) NSString *amount;
@property(nonatomic , copy) NSString *memo;
@property(nonatomic , copy) NSString *symbol;
@property(nonatomic , copy) NSString *contract;
@property(nonatomic , copy) NSString *precision;


/**
 status :comleted , faild , handling
 */
@property(nonatomic , copy) NSString *status;


@property(nonatomic , copy) NSString *resultStr;
@end

NS_ASSUME_NONNULL_END
