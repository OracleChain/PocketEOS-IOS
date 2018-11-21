//
//  PageSegmentView.h
//  PageSegment
//
//  Created by Hunter on 12/08/2017.
//  Copyright © 2017 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerHeader.h"

@class PageSegmentView;


@protocol PageSegmentViewDelegate <NSObject>

@required
- (NSUInteger)numberOfPagers:(PageSegmentView *)view;
- (UIViewController *)pagerViewOfPagers:(PageSegmentView *)view indexOfPagers:(NSUInteger)number;
@optional
/*!
 * @brief 切换到不同pager可执行的事件
 */
- (void)whenSelectOnPager:(NSUInteger)number;

- (void)pageSegmentleftBtnDidClick;
- (void)pageSegmentRightBtnDidClick;

@end



@interface PageSegmentView : UIView

@property (nonatomic, strong) UIScrollView   *tabView;

@property (nonatomic, weak)   id<PageSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIColor* tabBackgroundColor;
@property (nonatomic, strong) UIColor* tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor* tabButtonTitleColorForSelected;
@property (nonatomic, assign) CGFloat  tabFrameHeight;
@property (nonatomic, assign) CGFloat  tabButtonFontSize;
@property (nonatomic, assign) CGFloat  tabMargin;
@property (nonatomic, assign) CGFloat  selectedLineWidth;
@property (nonatomic, assign) CGFloat  selectedLineHeight;
// 顶部的 tabview 的 width
@property (nonatomic, assign) CGFloat  tabViewWidth;

/*!
 * @brief 自定义完毕后开始build UI（required）
 */
- (void)buildUI;
/*!
 * @brief 控制选中tab的button, 默认index = 0
 */
- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate;
- (void)showRedDotWithIndex:(NSUInteger)index;
- (void)hideRedDotWithIndex:(NSUInteger)index;



@property(nonatomic , strong) UIButton *leftBtn;
@property(nonatomic , strong) BaseView *rightView;
@end
