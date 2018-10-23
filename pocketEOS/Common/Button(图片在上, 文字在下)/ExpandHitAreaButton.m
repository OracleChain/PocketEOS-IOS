//
//  ExpandHitAreaButton.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ExpandHitAreaButton.h"

@implementation ExpandHitAreaButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectInset(self.bounds, -20, -20), point)) {
        return YES;
    }
    return NO;
}


@end
