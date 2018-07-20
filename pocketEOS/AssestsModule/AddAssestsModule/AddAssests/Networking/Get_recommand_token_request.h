//
//  Get_recommand_token_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface Get_recommand_token_request : BaseNetworkRequest
@property(nonatomic , copy) NSString *accountName;

/**
 一页显示的记录数
 */
@property(nonatomic, strong) NSNumber *size;

/**
 起始位置
 */
@property(nonatomic, strong) NSNumber *offset;

@property(nonatomic , strong) NSMutableArray *ids;

@end
