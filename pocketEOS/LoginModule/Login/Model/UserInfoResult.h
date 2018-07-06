//
//  UserInfoResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/5.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"
#import "UserInfo.h"

@interface UserInfoResult : BaseResult
@property(nonatomic , strong) UserInfo *data;
@end
