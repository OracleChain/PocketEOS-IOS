//
//  BPCandidateFooterView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateFooterView.h"

@implementation BPCandidateFooterView

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnDidClick)]) {
        [self.delegate confirmBtnDidClick];;
    }
}



@end
