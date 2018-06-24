//
//  BaseHeaderView.m
//  pocketEOS
//
//  Created by 师巍巍 on 24/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseHeaderView.h"

@implementation BaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeConfigBackgroundColor(@"baseHeaderView_background_color");
}

@end
