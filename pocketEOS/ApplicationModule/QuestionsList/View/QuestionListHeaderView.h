//
//  QuestionListHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionListHeaderViewDelegate<NSObject>
- (void)backBtnDidClick:(UIButton *)sender;
@end

@class SegmentControlView;
@interface QuestionListHeaderView : UIView
@property(nonatomic, weak) id<QuestionListHeaderViewDelegate> delegate;

@property(nonatomic, strong) SegmentControlView *segmentControlView;


- (void)updateViewWithArray:(NSMutableArray *)arr;

// 展示 BackgroundImg
- (void)showBackgroundImg;

// 隐藏 BackgroundImg
- (void)hideBackgroundImg;
@end
