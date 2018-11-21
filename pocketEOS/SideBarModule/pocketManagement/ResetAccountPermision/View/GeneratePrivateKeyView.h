//
//  GeneratePrivateKeyView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GeneratePrivateKeyViewDelegate <NSObject>



@end

@interface GeneratePrivateKeyView : UIView
@property(nonatomic, weak) id<GeneratePrivateKeyViewDelegate> delegate;
@property(nonatomic , strong) OptionModel *model;
@property(nonatomic , strong) UITextView *contentTextView;

@end

NS_ASSUME_NONNULL_END
