//
//  ApplicationMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/14.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@class Application;
@protocol ApplicationMainHeaderViewDelegate<NSObject>
- (void)starApplicationBtnDidClick:(UIButton *)sender;
- (void)top4ImgViewDidClick:(id)sender;
@end


@interface ApplicationMainHeaderView : UICollectionReusableView

@property(nonatomic, weak) id<ApplicationMainHeaderViewDelegate> delegate;



/**
 添加轮播图
 */
@property (weak, nonatomic) IBOutlet UIView *cycleScrollView;


- (void)updateViewWithArray:(NSArray *)array;

- (void)updateStarViewWithModel:(Application *)model;
@end
