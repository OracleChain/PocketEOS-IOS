//
//  SocialSharePanelView.m
//  pocketEOS
//
//  Created by oraclechain on 13/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "SocialSharePanelView.h"
#import "SWWButton.h"
#import "SocialShareModel.h"

@implementation SocialSharePanelView


- (void)updateViewWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    CGFloat itemWidth_height = 29;
    CGFloat selfWidth = self.frame.size.width;
    CGFloat item_margin;
    if (selfWidth >0 ) {
        item_margin = (selfWidth - (itemWidth_height * array.count)) / 5;
    }else{
        item_margin = (SCREEN_WIDTH - (itemWidth_height * array.count)) / 5;
    }
    
    for (int i = 0 ; i < array.count ; i ++) {
        SocialShareModel *model = array[i];
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:model.platformImage];
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        img.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, self.imageTopSpace ? self.imageTopSpace : 33, itemWidth_height, itemWidth_height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop4ImgView:)];
        [img addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.platformName;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x2A2A2A);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i-15, self.labelTopSpace+29+22, 60, itemWidth_height);
        [self addSubview:img];
        [self addSubview:label];
    }
}

- (void)tapTop4ImgView:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SocialSharePanelViewDidTap:)]) {
        [self.delegate SocialSharePanelViewDidTap: sender];
    }
}



@end
