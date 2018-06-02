//
//  SliderVerifyView.m
//
//
//  Created by oraclechain on 2017/12/14.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#define MARGIN_4 4
#define SLIDER_WIDTH 50
#define SLIDER_HEIGHT 40
#import "SliderVerifyView.h"

@interface SliderVerifyView()

{
    // 终点滑块的随机数起点, x
    int destinationRandomOrigin_X;
}
/**
 起点滑块
 */
@property(nonatomic, strong) UIImageView *orignalImg;

/**
 终点滑块
 */
@property(nonatomic, strong) UIImageView *destinationImg;

@end

@implementation SliderVerifyView

- (UIImageView *)orignalImg{
    if (!_orignalImg) {
        _orignalImg = [[UIImageView alloc] init];
        _orignalImg.lee_theme
        .LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:@"slider_white"])
        .LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:@"slider_blue"]);
        _orignalImg.layer.cornerRadius = 6;
        _orignalImg.layer.masksToBounds = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(orignalImgDidPan:)];
        [_orignalImg addGestureRecognizer:pan];
        _orignalImg.userInteractionEnabled = YES;
        _orignalImg.tag = 1000;
        
    }
    return _orignalImg;
}

- (UIImageView *)destinationImg{
    if (!_destinationImg) {
        _destinationImg = [[UIImageView alloc] init];
        _destinationImg.image = [UIImage imageNamed:@"slider_transparent"];
        _destinationImg.layer.cornerRadius = 6;
        _destinationImg.layer.masksToBounds = YES;
    }
    return _destinationImg;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.lee_theme
        .LeeAddTextColor(SOCIAL_MODE, HEXCOLOR(0xFFFFFF))
        .LeeAddTextColor(BLACKBOX_MODE, HEXCOLOR(0x0B78E3));
    }
    return _tipLabel;
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        destinationRandomOrigin_X = [self getRandomNumber: SCREEN_WIDTH/ 2 to: SCREEN_WIDTH - 54 - (48 * 2)];// 48 为 self 距左/右的边距
        self.lee_theme
        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0x4D7BFE))
        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = HEXCOLOR(0x4E7CFD).CGColor;
        
        [self addSubview:self.orignalImg];
        self.orignalImg.frame = CGRectMake(MARGIN_4, MARGIN_4, SLIDER_WIDTH, SLIDER_HEIGHT);
        
        [self addSubview:self.tipLabel];
        self.tipLabel.frame = CGRectMake(self.orignalImg.frame.origin.x + 50 + 15, 0, 100, 48);

        [self addSubview:self.destinationImg];
        self.destinationImg.frame = CGRectMake(destinationRandomOrigin_X, MARGIN_4, SLIDER_WIDTH, SLIDER_HEIGHT);
        [self bringSubviewToFront:self.orignalImg];
    }
    return self;
}

- (void)orignalImgDidPan:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:self];
        UIView *draggableObj = [self viewWithTag:1000];
        //通过计算偏移量来设定draggableObj的新坐标
        CGFloat newCenter_X = draggableObj.center.x + offset.x;
        
        if (newCenter_X < 30 || newCenter_X > self.width - 30) {
            // 限定滑动范围
            [draggableObj setCenter:CGPointMake(draggableObj.center.x , draggableObj.center.y )];

        }else{
            [draggableObj setCenter:CGPointMake(newCenter_X , draggableObj.center.y )];
            
        }
        
        NSLog(@"A:%d, B:%d", (int)newCenter_X, (int)(destinationRandomOrigin_X + SLIDER_WIDTH / 2));

        if (sender.state == UIGestureRecognizerStateEnded) {
            // 结束拖动的时候判断当前位置
            if (((int)newCenter_X >= destinationRandomOrigin_X + SLIDER_WIDTH / 2 - 10)  &&  ((int)newCenter_X <= destinationRandomOrigin_X + SLIDER_WIDTH / 2 + 10)) {
                
//                draggableObj.userInteractionEnabled = NO;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(sliderVerifyDidSuccess)]) {
                    [self.delegate sliderVerifyDidSuccess];
                }
                
            }else{
                [UIView animateWithDuration:1 animations:^{
                    [draggableObj setCenter:CGPointMake(MARGIN_4 + SLIDER_WIDTH/2 , draggableObj.center.y )];
                }];
            }
        }
        
        
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self];
    }
    
    
}
@end
