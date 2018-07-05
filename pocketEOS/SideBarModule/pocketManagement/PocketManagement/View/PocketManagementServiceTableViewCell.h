//
//  PocketManagementServiceTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/3.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PocketManagementServiceTableViewCell : BaseTableViewCell
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic, strong) OptionModel *model;

@end
