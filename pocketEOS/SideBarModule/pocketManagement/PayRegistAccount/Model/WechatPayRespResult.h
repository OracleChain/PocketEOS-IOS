//
//  WechatPayRespResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"
#import "WechatPayRespModel.h"

@interface WechatPayRespResult : BaseResult
@property(nonatomic , strong) WechatPayRespModel *data;
@end
