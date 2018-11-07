//
//  TransferDetailsHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferDetailsHeaderView : BaseView
@property (weak, nonatomic) IBOutlet BaseLabel *amountLabel;
@property (weak, nonatomic) IBOutlet BaseLabel *symbolNameLabel;

@end

NS_ASSUME_NONNULL_END
