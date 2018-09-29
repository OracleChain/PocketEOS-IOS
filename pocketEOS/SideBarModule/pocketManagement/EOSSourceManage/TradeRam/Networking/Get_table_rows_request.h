//
//  Get_table_rows_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseHttpsNetworkRequest.h"

@interface Get_table_rows_request : BaseHttpsNetworkRequest

@property(nonatomic , copy) NSString *code;
@property(nonatomic , copy) NSString *scope;
@property(nonatomic , copy) NSString *table;

@end
