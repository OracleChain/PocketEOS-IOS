//
//  TendencyChartView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/7.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "TendencyChartView.h"


typedef void(^completeBlock)(CAShapeLayer *borderShapeLayer, CAShapeLayer *shapeLayer, CAGradientLayer *gradientLayer);

@interface TendencyChartView()

@property (nonatomic, strong) CAShapeLayer *bulletBorderLayer; //曲线
@property (nonatomic, strong) CAShapeLayer *bulletLayer; //填充
@property (nonatomic, strong) CAGradientLayer *bulletGradientLayer; //渐变色填充

@end

@implementation TendencyChartView

- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc] init];
    }
    return _pointArray;
}

#pragma mark - public

- (void)quickShow{
    _bulletBorderLayer.hidden = NO;
    _bulletLayer.hidden = NO;
}


- (void)animation{
    _bulletBorderLayer.hidden = NO;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = 0.1;
    
    [_bulletBorderLayer addAnimation:animation1 forKey:nil];
    [self performSelector:@selector(bulletLayerAnimation) withObject:nil afterDelay:0.1];
}


- (void)bulletLayerAnimation{
    _bulletLayer.hidden = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    animation2.duration = 0.1;
    
    [_bulletLayer addAnimation:animation2 forKey:nil];
}


- (void)hide{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(bulletLayerAnimation) object:nil];
    [self.layer removeAllAnimations];
    _bulletLayer.hidden = YES;
    _bulletBorderLayer.hidden =  YES;
}



- (void)drawBulletLayer{
    
    WS(weakSelf);
    [self drawLayerWithPointArray:self.pointArray color:[UIColor redColor] compete:^(CAShapeLayer *borderShapeLayer, CAShapeLayer *shapeLayer, CAGradientLayer *gradientLayer) {
        weakSelf.bulletBorderLayer = borderShapeLayer;
        weakSelf.bulletLayer = shapeLayer;
        weakSelf.bulletGradientLayer = gradientLayer;
        weakSelf.bulletLayer.hidden = YES;
        weakSelf.bulletBorderLayer.hidden = YES;
    }];
}


- (void)drawLayerWithPointArray:(NSMutableArray *)pointArray color:(UIColor *)color compete:(completeBlock)compete{
    
    UIBezierPath *fillPath = [UIBezierPath new];
    UIBezierPath *borderPath = [UIBezierPath new];
    
    //    NSInteger ignoreSpace = pointArray.count / 2;
    
    __block CGPoint lastPoint;
    __block NSUInteger  lastIdx;
    
    // 求出最大值 ,
    NSMutableArray *point_x_array = [NSMutableArray array];
    NSMutableArray *point_y_array = [NSMutableArray array];
    for (NSValue *value in pointArray) {
        CGPoint point = value.CGPointValue;
        [point_x_array addObject: [NSNumber numberWithFloat:point.x]];
        [point_y_array addObject: [NSNumber numberWithFloat:point.y]];
    }
    CGFloat maxValue_y = [[point_y_array valueForKeyPath:@"@max.floatValue"] floatValue];
    // point.y最大值占 self.height 的比例
    CGFloat ratio_y = self.frame.size.height / maxValue_y;
    
    CGFloat maxValue_x = [[point_x_array valueForKeyPath:@"@max.floatValue"] floatValue];
    // point.x最大值占 self.width 的比例
    CGFloat ratio_x = self.frame.size.width / maxValue_x;
    
    
    [fillPath moveToPoint:CGPointMake(0, self.frame.size.height)];
    [pointArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CGPoint point = obj.CGPointValue;
        // 将 point.y 变为从下往上, (默认是从上往下)
        point.y = self.frame.size.height - point.y * ratio_y ;
        point.x = point.x * ratio_x ;

        
        if (idx == 0) { //第一个点
            
            [fillPath addLineToPoint:point];
            [borderPath moveToPoint:point];
            lastPoint = point;
            lastIdx = idx;
        } else if ((idx == pointArray.count - 1) || (point.y == 0) || (lastIdx + 0 + 1 == idx)) { //最后一个点最高点要画/当点数过多时 忽略部分点
            
            [fillPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x+point.x)/2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x+point.x)/2, point.y)]; //三次曲线
            
            [borderPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x+point.x)/2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x+point.x)/2, point.y)]; //三次曲线
            lastPoint = point;
            lastIdx = idx;
        }
    }];
    [fillPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [fillPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = fillPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.path = borderPath.CGPath;
    borderShapeLayer.lineWidth = 2.f;
    borderShapeLayer.strokeColor =HEXCOLOR(0x0577DC).CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:borderShapeLayer];
    
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[HEXCOLOR(0x35BEF8) colorWithAlphaComponent:0.31] CGColor], (id)[[HEXCOLOR(0x1889EE) colorWithAlphaComponent:0.06] CGColor], nil]];
    [gradientLayer setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer setMask:shapeLayer];
    [self.layer addSublayer:gradientLayer];
    
    
    compete(borderShapeLayer, shapeLayer, gradientLayer);
}

@end
