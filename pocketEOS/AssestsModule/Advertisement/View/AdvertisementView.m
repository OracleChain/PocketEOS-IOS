//
//  AdvertisementView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AdvertisementView.h"

@implementation AdvertisementView


- (IBAction)goforward:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goforwardDidClick)]) {
        [self.delegate goforwardDidClick];
    }
}

- (IBAction)dismiss:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
