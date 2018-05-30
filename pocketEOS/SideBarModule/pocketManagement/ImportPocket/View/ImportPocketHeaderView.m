//
//  ImportPocketHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/12.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ImportPocketHeaderView.h"

@implementation ImportPocketHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.pocketTextView.layer.borderWidth = 1.0f;
    self.pocketTextView.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
}

- (IBAction)importPocket:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importPocketBtnDidClick:)]) {
        [self.delegate importPocketBtnDidClick:sender];
    }
    
}

@end
