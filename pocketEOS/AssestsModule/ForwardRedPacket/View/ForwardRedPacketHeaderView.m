//
//  ForwardRedPacketHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "ForwardRedPacketHeaderView.h"

@implementation ForwardRedPacketHeaderView

- (IBAction)continueSendRedPacket:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(continueSendRedPacketBtnDidClick:)]) {
        [self.delegate continueSendRedPacketBtnDidClick:sender];
    }
}


@end
