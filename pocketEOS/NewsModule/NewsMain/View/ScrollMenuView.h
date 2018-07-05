//
//  ScrollMenuView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/5.
//  Copyright © 2018 oraclechain. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Assest.h"

@protocol ScrollMenuViewDelegate<NSObject>
- (void)menuScrollViewItemBtnDidClick:(UIButton *)sender;
@end

@interface ScrollMenuView : UIView

@property(nonatomic, weak) id<ScrollMenuViewDelegate> delegate;
- (void)updateViewWithAssestsArray:(NSArray<Assest *> *)assestsArray;
@end
