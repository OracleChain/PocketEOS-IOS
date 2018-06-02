//
//  BaseTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 17/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "BaseSlimLineView.h"


@interface BaseTableViewCell : MGSwipeTableCell
@property(nonatomic , strong) UIImageView *rightIconImageView;
@property(nonatomic , copy) NSString *rightIconImgName;
@property(nonatomic , strong) BaseSlimLineView *bottomLineView;
@end
