//
//  CAlayerView.m
//  设计模式
//
//  Created by viveco on 2018/3/13.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "CAlayerView.h"

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface CAlayerView()

@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) CAShapeLayer *shaperLayer;

@end

@implementation CAlayerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setValue:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1] forKey:@"backgroundColor"];
        _slider = [[UISlider alloc] init];
        _slider.frame = G_R(50, 50, 300,40);
        _slider.maximumValue = 360;
        _slider.minimumTrackTintColor=[UIColor redColor];
        _slider.maximumTrackTintColor=[UIColor blueColor];
        _slider.thumbTintColor=[UIColor blackColor];
        [_slider addTarget:self action:@selector(pressSlider) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        [self initSubView];
    }return self;
}

- (void)initSubView{
    
    CALayer * layer = [CALayer layer];

    layer.frame = G_R(100, 250, 250, 250);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;
    layer.contents = CFBridgingRelease([UIImage imageNamed:@"piano.png"].CGImage);
    layer.contentsRect = CGRectMake(0,0, 1,1);
    layer.cornerRadius = 10;
//    layer.shadowColor = [UIColor blueColor].CGColor;
    layer.opacity = 1; // 类似 alpha
    [self.layer addSublayer:layer];
    
    
    
    CAShapeLayer * shaper = [CAShapeLayer layer];
    shaper.frame = CGRectMake(100, 250, 200, 200);
    shaper.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)].CGPath;
    shaper.position = G_P(100,100);
    shaper.fillColor = [UIColor blueColor].CGColor;
    shaper.lineWidth = 10;
    shaper.strokeEnd =0.95;
    shaper.lineJoin = kCALineJoinRound;
    shaper.lineCap = kCALineCapRound;
    self.shaperLayer = shaper;
    [layer addSublayer:self.shaperLayer];
    
}

- (void)pressSlider{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    CGFloat endangle = self.slider.value * M_PI * 2 / self.slider.maximumValue;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(125, 125)];
    [path addArcWithCenter:CGPointMake(125, 125) radius:100 startAngle:0 endAngle:endangle clockwise:YES];
    [path addLineToPoint:CGPointMake(125, 125)];
    
    _shaperLayer.path = path.CGPath;
    
   
}
//// 什么时候调用
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//
//    CGContextSetRGBFillColor(ctx, 0.8, 0.8, 0.8, 1);
//    CGContextSetLineWidth(ctx, 4);
//    CGContextAddRect(ctx, layer.bounds);
//    CGContextStrokePath(ctx);
//}

//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    layer.position = G_P(100, 100);
//    [CATransaction commit];


@end
