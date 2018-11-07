//
//  AboutUsHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "Get_pocketeos_info_Result.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AboutUsHeaderViewDelegate <NSObject>



@end

@interface AboutUsHeaderView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *versionUpdateLabel;

@property (weak, nonatomic) IBOutlet BaseTextView_textColorLightGray *AboutUsdetailTextView;



@property(nonatomic, weak) id<AboutUsHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet BaseLabel1 *wechatSubscriptionLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *wechatServiceLabel;


- (void)updateViewWithModel:(Get_pocketeos_info_Result *)model;

@end

NS_ASSUME_NONNULL_END
