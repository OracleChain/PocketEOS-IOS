//
//  ApplicationHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationHeaderViewModel.h"
#import "SDCycleScrollView.h"
#import "Enterprise.h"

@protocol ApplicationHeaderViewDelegate<NSObject>
- (void)starApplicationBtnDidClick:(UIButton *)sender;
- (void)top4ImgViewDidClick:(id)sender;
@end

@interface ApplicationHeaderView : UICollectionReusableView
@property(nonatomic, weak) id<ApplicationHeaderViewDelegate> delegate;



- (void)updateViewWithModel:(ApplicationHeaderViewModel *)model;


@end
