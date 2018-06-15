//
//  BPVoteHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountResult.h"

@protocol BPVoteHeaderViewDelegate<NSObject>
- (void)changeAccountBtnDidClick:(UIButton *)sender;
@end


@interface BPVoteHeaderView : UIView

@property(nonatomic, weak) id<BPVoteHeaderViewDelegate> delegate;
@property(nonatomic , strong) AccountResult *model;

@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceOfVotedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@end
