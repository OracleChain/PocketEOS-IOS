//
//  ForwardRedPacketHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForwardRedPacketHeaderViewDelegate <NSObject>
- (void)continueSendRedPacketBtnDidClick:(UIButton *)sender;

@end

@interface ForwardRedPacketHeaderView : BaseView


@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountTipLabel;

@property(nonatomic, weak) id<ForwardRedPacketHeaderViewDelegate> delegate;

@end
