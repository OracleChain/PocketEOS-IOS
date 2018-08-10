//
//  CreateAccountResourceRespModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateAccountResourceRespModel : NSObject

@property(nonatomic , strong) NSNumber *cnyCost;
@property(nonatomic , copy) NSString *ram;
@property(nonatomic , copy) NSString *net;
@property(nonatomic , copy) NSString *cpu;

@end
