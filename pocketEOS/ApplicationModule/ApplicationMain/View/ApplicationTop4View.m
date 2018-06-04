//
//  ApplicationTop4View.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ApplicationTop4View.h"

@implementation ApplicationTop4View


- (void)updateViewWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    CGFloat itemWidth_height = 45;
    CGFloat item_margin = (SCREEN_WIDTH - (itemWidth_height * array.count)) / 5;
    for (int i = 0 ; i < array.count ; i ++) {
        Enterprise *model = array[i];
        UIImageView *img = [[UIImageView alloc] init];
        [img sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.enterpriseIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        img.sd_cornerRadius = @(itemWidth_height / 2);
        img.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, 20, itemWidth_height, itemWidth_height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop4ImgView:)];
        [img addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.enterpriseName;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        
        label.frame = CGRectMake(item_margin + (itemWidth_height + item_margin)*i, 65, itemWidth_height, itemWidth_height);
        [self addSubview:img];
        [self addSubview:label];
    }
}


- (void)tapTop4ImgView:(UIGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(top4ImgViewDidClick:)]) {
        [self.delegate top4ImgViewDidClick: sender];
    }
}
@end
