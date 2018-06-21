//
//  EOSResourceResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceResult.h"

@implementation EOSResourceResult

- (EOSResource *)data{
    if (!_data) {
        _data = [[EOSResource alloc] init];
    }
    return _data;
}

@end
