//
//  TypeChainId.m
//  啊啊啊啊啊啊
//
//  Created by 师巍巍 on 03/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TypeChainId.h"

@interface TypeChainId()
{
    const NSData *mId;
}
@end

@implementation TypeChainId

- (instancetype)init {
    if (self = [super init]) {
        const Byte byte[32] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        mId = [NSData dataWithBytes:byte length:32];
    }
    return self;
}

- (const void *)getBytes {
    
    return [mId bytes];
}
- (const NSData *)chainId{
    
    return mId;
}

@end
