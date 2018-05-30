//
//  VersionUpdateHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "VersionUpdateHeaderView.h"

@implementation VersionUpdateHeaderView
- (IBAction)versionIntroduce:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(versionIntroduceBtnDidClick:)]) {
        [self.delegate versionIntroduceBtnDidClick:sender];
    }
}
- (IBAction)checkNewVersion:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkNewVersionBtnDidClick:)]) {
        [self.delegate checkNewVersionBtnDidClick:sender];
    }
}


@end
