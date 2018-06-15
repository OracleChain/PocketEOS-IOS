
//
//  BPAgentVoteHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPAgentVoteHeaderView.h"

@implementation BPAgentVoteHeaderView

- (IBAction)chooseAgentBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseAgentBtnDidClick:)]) {
        [self.delegate chooseAgentBtnDidClick:sender];
    }
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmAgentBtnDidClick:)]) {
        [self.delegate confirmAgentBtnDidClick:sender];
    }
}

@end
