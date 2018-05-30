//
//  AskQuestionTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/11.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AskQuestionTableViewCell;
@protocol AskQuestionTableViewCellDelegate<NSObject>

- (void)deleteCurrentRowBtnDidClick:(AskQuestionTableViewCell *)sender;

@end

@class AskQuestionModel;
@interface AskQuestionTableViewCell : BaseTableViewCell

@property(nonatomic, weak) id<AskQuestionTableViewCellDelegate> delegate;

@property(nonatomic, strong) AskQuestionModel *model;


/**
 编辑选项的 textView
 */
@property(nonatomic, strong) BaseTextView *editTextView;
/**
 删除当前选项
 */
@property(nonatomic, strong) UIButton *deleteBtn;


@end
