//
//  PeRichListService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/25.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "PeRichListRequest.h"

@interface PeRichListService : BaseService
@property(nonatomic, strong) PeRichListRequest *peRichListRequest;
- (void)buildNextPageDataSource:(CompleteBlock)complete;
@end
