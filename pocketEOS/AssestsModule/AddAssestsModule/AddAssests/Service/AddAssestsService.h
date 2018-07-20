//
//  AddAssestsService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "Get_recommand_token_request.h"
#import "Search_token_request.h"

@interface AddAssestsService : BaseService

@property(nonatomic , strong) Get_recommand_token_request *get_recommand_token_request;
@property(nonatomic , strong) Search_token_request *search_token_request;


@property(nonatomic , strong) NSMutableArray *searchTokenResultDataArray;
@property(nonatomic , strong) NSMutableArray *followAssetIdsDataArray;
/**
 search_token
 */
- (void)search_token:(CompleteBlock)complete;



- (void)buildNextPageDataSource:(CompleteBlock)complete;
@end
