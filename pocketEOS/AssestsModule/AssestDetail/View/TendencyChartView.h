//
//  TendencyChartView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/7.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

// 趋势图
@interface TendencyChartView : UIView

/**
 传入数据模型
 */
@property(nonatomic, strong) NSMutableArray *pointArray;

/**
 开始动画
 */
- (void)animation;

/**
 快速展示
 */
- (void)quickShow;

/**
 隐藏
 */
- (void)hide;


- (void)drawBulletLayer;
@end
