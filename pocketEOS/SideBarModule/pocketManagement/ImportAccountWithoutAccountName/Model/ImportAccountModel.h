//
//  ImportAccountModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImportAccountModel : NSObject
@property(nonatomic , copy) NSString *accountName;
@property(nonatomic , copy) NSString *ownerPrivateKey;
@property(nonatomic , copy) NSString *activePrivateKey;

 // 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在 4:权限错误
@property(nonatomic , assign) NSUInteger status;
@end

NS_ASSUME_NONNULL_END
