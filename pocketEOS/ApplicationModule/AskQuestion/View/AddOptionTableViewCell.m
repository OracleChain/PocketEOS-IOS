//
//  AddOptionTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/11.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AddOptionTableViewCell.h"

@implementation AddOptionTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat btnWidth = SCREEN_WIDTH - MARGIN_20 * 2;
        CGFloat btnHeight = 36;
        CGFloat cornerRadius = 3;
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = @"添加选项";
        lable.userInteractionEnabled = YES;
        lable.textColor = HEXCOLOR(0xCECECE);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = CGRectMake(MARGIN_20, 2, btnWidth, btnHeight);
        lable.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        
        [lable.layer setCornerRadius:cornerRadius];
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        borderLayer.position = CGPointMake(CGRectGetMidX(lable.bounds), CGRectGetMidY(lable.bounds));
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:cornerRadius].CGPath;
        borderLayer.lineWidth = 1;
        borderLayer.lineDashPattern = @[@8, @8];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = HEXCOLOR(0xCECECE).CGColor;
        [lable.layer addSublayer:borderLayer];
        
        [self.contentView addSubview:lable];
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    NSLog(@"sssss");
}
@end
