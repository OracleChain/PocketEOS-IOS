//
//  AskQuestionHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AskQuestionHeaderViewDelegate<NSObject>

- (void)chooseTimeBtnDidClick:(UIButton *)sender;
@end


@interface AskQuestionHeaderView : BaseView
@property(nonatomic, weak) id<AskQuestionHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *chooseTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *titleTV;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;


@end
