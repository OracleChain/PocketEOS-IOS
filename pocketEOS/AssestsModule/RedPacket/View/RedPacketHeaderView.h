//
//  RedPacketHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RedPacketHeaderViewDelegate<NSObject>

- (void)sendRedPacket:(UIButton *)sender;
- (void)selectAccountBtnDidClick:(UIButton *)sender;
- (void)selectAssestsBtnDidClick:(UIButton *)sender;

@end

@interface RedPacketHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *accountChooserLabel;
@property (weak, nonatomic) IBOutlet UILabel *assestChooserLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *redPacketCountTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRedpacketBtn;

@property(nonatomic, weak) id<RedPacketHeaderViewDelegate> delegate;

@end
