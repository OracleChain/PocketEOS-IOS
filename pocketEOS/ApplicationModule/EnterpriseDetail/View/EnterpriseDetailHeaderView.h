//
//  EnterpriseDetailHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterpriseDetailHeaderViewDelegate<NSObject>
- (void)recommandBtnDidClick:(UIButton *)sender;

@end

@class Enterprise;
@class Application;
@interface EnterpriseDetailHeaderView : UICollectionReusableView
@property(nonatomic, weak) id<EnterpriseDetailHeaderViewDelegate> delegate;

- (void)updateViewWithModel:(Enterprise *)model;
- (void)upadteRecommandViewWithModel:(Application *)model;
@end
