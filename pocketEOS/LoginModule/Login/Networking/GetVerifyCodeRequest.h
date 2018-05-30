//
//  GetVerifyCodeRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetVerifyCodeRequest : BaseNetworkRequest

/**
 手机号
 */
@property(nonatomic, strong) NSString *phoneNum;
@end
