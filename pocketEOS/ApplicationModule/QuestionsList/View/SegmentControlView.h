//
//  SegmentControlView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentControlViewDelegate<NSObject>

- (void)segmentControlBtnDidClick:(UIButton *)sender;
@end

/**
 头部选项卡
 */
@interface SegmentControlView : UIView


- (void)updateViewWithArray:(NSMutableArray *)arr;
@property(nonatomic, weak) id<SegmentControlViewDelegate> delegate;
@end
