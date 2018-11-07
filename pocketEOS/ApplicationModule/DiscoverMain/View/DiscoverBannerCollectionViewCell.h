//
//  DiscoverBannerCollectionViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DappModel.h"
#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverBannerCollectionViewCell : BaseCollectionViewCell


@property(nonatomic , strong) DappModel *model;
@end

NS_ASSUME_NONNULL_END
