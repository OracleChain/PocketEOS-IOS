//
//  RedPacketPrepareDetailView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketPrepareDetailView.h"

@implementation RedPacketPrepareDetailView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.confirmProcessLabel.font = [UIFont boldSystemFontOfSize:12];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyRedpacket_idToPasteboard:)];
    self.redpacket_id_label.userInteractionEnabled = YES;
    [self.redpacket_id_label addGestureRecognizer:longPressGesture];
    
    UILongPressGestureRecognizer *longPressGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyTx_idToPasteboard:)];
    self.tx_id_label.userInteractionEnabled = YES;
    [self.tx_id_label addGestureRecognizer:longPressGesture1];
    
}


- (void)copyRedpacket_idToPasteboard:(UILongPressGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}

- (void)copyTx_idToPasteboard:(UILongPressGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}


@end
