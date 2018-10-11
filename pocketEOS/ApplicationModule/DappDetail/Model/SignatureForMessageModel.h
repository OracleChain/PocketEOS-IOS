//
//  SignatureForMessageModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignatureForMessageModel : NSObject
@property(nonatomic , copy) NSString *publicKey;
@property(nonatomic , copy) NSString *data;
@property(nonatomic , copy) NSString *whatfor;
@property(nonatomic , assign) BOOL isHash;
@end
