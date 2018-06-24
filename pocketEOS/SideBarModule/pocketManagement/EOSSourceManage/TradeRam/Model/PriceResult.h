//
//  PriceResult.h
//  pocketEOS
//
//  Created by 师巍巍 on 22/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PriceModel;
@interface PriceResult : NSObject

@property (nonatomic , strong) NSNumber *code;
@property (nonatomic , copy) NSString *message;
@property (nonatomic , strong) PriceModel *data;

@end
