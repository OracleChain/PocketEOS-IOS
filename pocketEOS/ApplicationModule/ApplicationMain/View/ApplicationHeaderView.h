//
//  ApplicationHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationHeaderViewModel.h"


@interface ApplicationHeaderView : UICollectionReusableView

- (void)updateViewWithModel:(ApplicationHeaderViewModel *)model;


@end
