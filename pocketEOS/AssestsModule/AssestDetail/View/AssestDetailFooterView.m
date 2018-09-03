//
//  AssestDetailFooterView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestDetailFooterView.h"

@implementation AssestDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *imageArr = @[@"transfer_icon", @"recieve_white" , @"redpacket_icon"];
        if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE)  {
            arr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"发起转账", nil), NSLocalizedString(@"资产收款", nil), nil];
        }else if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE){
            arr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"发起转账", nil), NSLocalizedString(@"资产收款", nil), NSLocalizedString(@"发红包", nil), nil];
        }
        CGFloat itemWidth = SCREEN_WIDTH/arr.count;
        CGFloat itemheight = TABBAR_HEIGHT;
        for (int i = 0 ; i < arr.count ; i ++) {
            Enterprise *model;
            UIView *baseView = [[UIView alloc] init];
            baseView.backgroundColor = HEXCOLOR(0x0B78E3);
            baseView.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemheight);
            [self addSubview:baseView];
            
            UIImageView *img = [[UIImageView alloc] init];
            [img sd_setImageWithURL:String_To_URL(VALIDATE_STRING(imageArr[i])) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
            img.image = [UIImage imageNamed:imageArr[i]];
            img.frame = CGRectMake(itemWidth/2-40 ,18, 16, 16);
            
            UILabel *label = [[UILabel alloc] init];
            label.text = arr[i];
            label.textColor = HEXCOLOR(0xFFFFFF);
            label.font = [UIFont systemFontOfSize:14];
            label.frame = CGRectMake((itemWidth/2) - 40 + 16 + 11 , 16, 60, MARGIN_20);
            label.textAlignment = NSTextAlignmentLeft;
            

            
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 1000 + i;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(assestsFooterViewClick:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.frame = baseView.bounds;
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HEXCOLOR(0xFFFFFF);
            line.alpha = 0.26;
            line.frame = CGRectMake(itemWidth - 1, 0, DEFAULT_LINE_HEIGHT, itemheight);


            [baseView addSubview:img];
            [baseView addSubview:label];
            [baseView addSubview:btn];
            [baseView addSubview:line];
        }
        
        
        
    }
    return self;
}


- (void)assestsFooterViewClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assestsDetailFooterViewDidClick:)]) {
        [self.delegate assestsDetailFooterViewDidClick:sender];
    }
}


@end
