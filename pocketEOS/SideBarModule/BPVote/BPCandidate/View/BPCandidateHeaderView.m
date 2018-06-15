//
//  BPCandidateHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPCandidateHeaderView.h"

@implementation BPCandidateHeaderView

- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBtnDidClick:)]) {
        [self.delegate searchBtnDidClick:sender];
    }
}


@end
