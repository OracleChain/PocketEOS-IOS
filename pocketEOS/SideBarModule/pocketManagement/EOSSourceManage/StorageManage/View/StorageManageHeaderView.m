//
//  StorageManageHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "StorageManageHeaderView.h"

@interface StorageManageHeaderView()
@property (weak, nonatomic) IBOutlet BaseView *baseTopView;

@end

@implementation StorageManageHeaderView

- (IBAction)buyRamBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyRamBtnDidClick:)]) {
        [self.delegate buyRamBtnDidClick:sender];
    }
}

- (IBAction)sellRamBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellRamBtnDidClick:)]) {
        [self.delegate sellRamBtnDidClick:sender];
    }
}

@end
