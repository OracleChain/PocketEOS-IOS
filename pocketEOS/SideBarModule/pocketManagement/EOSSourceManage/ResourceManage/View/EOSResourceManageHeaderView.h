//
//  EOSResourceManageHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "SegmentControlView.h"

@interface EOSResourceManageHeaderView : BaseView
- (void)updateViewWithArray:(NSMutableArray *)arr;
@property(nonatomic, strong) SegmentControlView *segmentControlView;
@property (weak, nonatomic) IBOutlet BaseLabel *eosAmountLabel;
@end
