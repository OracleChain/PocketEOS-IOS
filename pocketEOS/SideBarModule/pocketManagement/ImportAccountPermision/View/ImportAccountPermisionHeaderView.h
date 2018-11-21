//
//  ImportAccountPermisionHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImportAccountPermisionHeaderViewDelegate <NSObject>

- (void)importAccountPermisionHeaderViewConfirmBtnDidClick;
- (void)importAccountPermisionHeaderViewResetPrivateKeyBtnDidClick;

@end

@interface ImportAccountPermisionHeaderView : UIView
@property(nonatomic, weak) id<ImportAccountPermisionHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *resetPrivateKeyBtn;


@end

NS_ASSUME_NONNULL_END
