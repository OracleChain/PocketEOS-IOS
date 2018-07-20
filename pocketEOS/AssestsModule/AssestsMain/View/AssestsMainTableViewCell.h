//
//  AssestsMainTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenInfo.h"

@interface AssestsMainTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *assestsPriceChangeLabel;
@property(nonatomic, strong) TokenInfo *model;
@end
