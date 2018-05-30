//
//  NewsMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol NewsMainHeaderViewDelegate<NSObject>
- (void)currentAssestsLabelDidTap:(UITapGestureRecognizer *)sender;
@end

@interface NewsMainHeaderView : UIView

@property(nonatomic, weak) id<NewsMainHeaderViewDelegate> delegate;

/**
 轮播图
 */
@property(nonatomic, strong) SDCycleScrollView *scrollView;

/**
 箭头
 */
@property(nonatomic, strong) UIImageView *arrowImg;


/**
 当前选中的 资产
 */
@property(nonatomic, strong) BaseLabel *currentAssestsLabel;


@end
