//
//  Permissions.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/6.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Permission : NSObject

// active / owner  
@property(nonatomic, copy) NSString *perm_name;
// active / owner  public key
@property(nonatomic, copy) NSString *required_auth_key;


@property(nonatomic , strong) NSArray *required_auth_keyArray;

@end
