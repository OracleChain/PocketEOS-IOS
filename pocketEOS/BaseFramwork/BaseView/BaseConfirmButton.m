//
//  BaseConfirmButton.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseConfirmButton.h"

@implementation BaseConfirmButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0x4D7BFE))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x0B78E3));
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0x4D7BFE))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x0B78E3));
}
@end
