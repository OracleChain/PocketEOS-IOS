//
//  EOSResourceManageHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceManageHeaderView.h"


@interface EOSResourceManageHeaderView()
@property (weak, nonatomic) IBOutlet UIView *segmentControlBaseView;



@end



@implementation EOSResourceManageHeaderView

- (SegmentControlView *)segmentControlView{
    if (!_segmentControlView) {
        _segmentControlView = [[SegmentControlView alloc] init];
    }
    return _segmentControlView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.segmentControlBaseView addSubview:self.segmentControlView];
    self.segmentControlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
}

- (void)updateViewWithArray:(NSMutableArray *)arr{
    [self.segmentControlView updateViewWithArray:arr];
}

@end
