//
//  IndexTipView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/3.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "IndexTipView.h"

@interface IndexTipView()
@property(nonatomic, strong) UIImageView *ovalImg;
@property(nonatomic, strong) UILabel *titleLabel;
@end


@implementation IndexTipView

- (UIImageView *)ovalImg{
    if (!_ovalImg) {
        _ovalImg = [[UIImageView alloc] init];
        _ovalImg.image = [UIImage imageNamed:@"oval"];
        _ovalImg.frame = CGRectMake(0, 0, 40, 33);
    }
    return _ovalImg;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, 40, 33);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.ovalImg];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setText:(NSString *)text{
    self.titleLabel.text = text;
}

@end
