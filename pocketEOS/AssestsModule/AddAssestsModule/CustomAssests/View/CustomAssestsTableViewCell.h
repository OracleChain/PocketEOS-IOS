//
//  CustomAssestsTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CustomToken.h"

@interface CustomAssestsTableViewCell : BaseTableViewCell
@property(nonatomic , strong) CustomToken *model;

@property(nonatomic , copy)void(^onTrashImageDidTapBlock)(CustomToken *);

@end
