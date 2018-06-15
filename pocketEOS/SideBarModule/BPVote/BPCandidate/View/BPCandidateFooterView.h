//
//  BPCandidateFooterView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPCandidateFooterViewDelegate<NSObject>
- (void)confirmBtnDidClick;
@end


@interface BPCandidateFooterView : UIView
@property(nonatomic, weak) id<BPCandidateFooterViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
