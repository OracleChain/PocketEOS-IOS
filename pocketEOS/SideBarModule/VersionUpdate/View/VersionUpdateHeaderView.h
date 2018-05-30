//
//  VersionUpdateHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VersionUpdateHeaderViewDelegate<NSObject>
- (void)versionIntroduceBtnDidClick:(UIButton *)sender;
- (void)checkNewVersionBtnDidClick:(UIButton *)sender;
@end

@interface VersionUpdateHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property(nonatomic, weak) id<VersionUpdateHeaderViewDelegate> delegate;
@end
