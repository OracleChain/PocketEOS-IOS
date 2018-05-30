//
//  DappTransferModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DappTransferModel : NSObject
@property(nonatomic , copy) NSString *from;
@property(nonatomic , copy) NSString *to;
@property(nonatomic , copy) NSString *quantity;
@property(nonatomic , copy) NSString *memo;
@property(nonatomic , strong) NSNumber *serialNumber;
@end
