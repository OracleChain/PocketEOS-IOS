//
//  RecommandTokensResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandTokensResult : NSObject
@property(nonatomic, strong) NSMutableArray *assetCategoryList;
@property(nonatomic, strong) NSMutableArray *followAssetIds;
@end
