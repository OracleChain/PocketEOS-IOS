//
//  EOSResourceResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSResource.h"

@interface EOSResourceResult : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) EOSResource *data;
@end
