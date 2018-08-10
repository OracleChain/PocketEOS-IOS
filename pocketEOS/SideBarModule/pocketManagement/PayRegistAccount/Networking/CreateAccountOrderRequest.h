//
//  CreateAccountOrderRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface CreateAccountOrderRequest : BaseNetworkRequest
//0-微信，1-阿里
@property(nonatomic , copy) NSString *payChannel;

@property(nonatomic , copy) NSString *accountName;

@property(nonatomic , copy) NSString *openid;

@property(nonatomic , copy) NSString *timeOut;

@property(nonatomic , copy) NSString *feeAmount;

@property(nonatomic , copy) NSString *userId;

@property(nonatomic , copy) NSString *ownerKey;

@property(nonatomic , copy) NSString *activeKey;



@end
