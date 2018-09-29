//
//  CommonDialogHasTitleView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/25.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonDialogHasTitleViewDelegate<NSObject>
//- (void)skipBtnDidClick:(UIButton *)sender;
- (void)commonDialogHasTitleViewBtnDidClick:(UIButton *)sender;
@end


@interface CommonDialogHasTitleView : UIView

@property(nonatomic , strong) OptionModel *model;

@property(nonatomic, weak) id<CommonDialogHasTitleViewDelegate> delegate;

@end
