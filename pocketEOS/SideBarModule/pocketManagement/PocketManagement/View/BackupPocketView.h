//
//  BackupPocketView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BackupPocketViewDelegate<NSObject>

- (void)iconImgDidTap:(UIGestureRecognizer *)sender;
@end

@interface BackupPocketView : UIView
@property (weak, nonatomic) IBOutlet UILabel *backupPocketTitleLabel;
@property(nonatomic, weak) id<BackupPocketViewDelegate> delegate;


@end
