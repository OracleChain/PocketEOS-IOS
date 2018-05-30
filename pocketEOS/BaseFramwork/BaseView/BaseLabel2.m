//
//  BaseLabel2.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseLabel2.h"

@implementation BaseLabel2

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.lee_theme.LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x666666)).LeeAddTextColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF));
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lee_theme.LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0x666666)).LeeAddTextColor(BLACKBOX_MODE, HEXCOLOR(0xFFFFFF));
}
@end
