//
//  DiscoverMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "Get_recommend_dapp_result.h"
#import "DappModel.h"
#import "ScrollMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DiscoverMainHeaderViewDelegate<NSObject>

- (void)menuScrollViewItemBtnDidClick:(UIButton *)sender;


- (void)tyCyclePagerViewDidSelectedItemCell:(DappModel *)model;

- (void)recommendDappImgViewDidTap:(DappModel *)model;

- (void)starDappImgViewDidTap:(DappModel *)model;

- (void)discoverMainHeaderViewDappItemDidClick:(DappModel *)model;
@end

@interface DiscoverMainHeaderView : BaseView

@property(nonatomic, weak) id<DiscoverMainHeaderViewDelegate> delegate;
@property(nonatomic , strong) ScrollMenuView *scrollMenuView;




- (void)updateViewWithModel:(Get_recommend_dapp_result *)model;

@property(nonatomic , strong) Get_recommend_dapp_result *model;

@end

NS_ASSUME_NONNULL_END
