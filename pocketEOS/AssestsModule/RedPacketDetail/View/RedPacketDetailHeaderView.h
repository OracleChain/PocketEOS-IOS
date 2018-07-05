//
//  RedPacketDetailHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketDetailHeaderViewDelegate<NSObject>
- (void)sendRedPacketBtnDidClick;
@end


@interface RedPacketDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRedpacketBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property(nonatomic, weak) id<RedPacketDetailHeaderViewDelegate> delegate;

@end
