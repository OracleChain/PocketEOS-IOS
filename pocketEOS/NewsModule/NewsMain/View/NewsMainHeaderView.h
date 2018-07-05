//
//  NewsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "Assest.h"
#import "ScrollMenuView.h"

@protocol NewsMainHeaderViewDelegate<NSObject>
- (void)menuScrollViewItemBtnDidClick:(UIButton *)sender;
@end

@interface NewsMainHeaderView : UIView

@property(nonatomic, weak) id<NewsMainHeaderViewDelegate> delegate;

/**
 轮播图
 */
@property(nonatomic, strong) SDCycleScrollView *scrollView;
@property(nonatomic , strong) ScrollMenuView *scrollMenuView;

- (void)updateViewWithAssestsArray:(NSArray<Assest *> *)assestsArray;

@property(nonatomic , strong) NSMutableArray *assestsArray;

@end
