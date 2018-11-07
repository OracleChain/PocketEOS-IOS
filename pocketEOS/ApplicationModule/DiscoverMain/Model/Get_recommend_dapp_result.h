//
//  Get_recommend_dapp_result.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface Get_recommend_dapp_result : BaseResult

@property(nonatomic , strong) NSArray *bannerDapps;
@property(nonatomic , strong) NSArray *introDapps;
@property(nonatomic , strong) NSArray *starDapps;

@end

NS_ASSUME_NONNULL_END
