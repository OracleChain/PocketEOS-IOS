//
//  ApplicationCollectionViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"
@class Application;
@interface ApplicationCollectionViewCell : BaseCollectionViewCell

@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;

- (void)updateViewWithModel:(Application *)model;

@end
