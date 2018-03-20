//
//  YSWaterWaveView.m
//  设计模式
//
//  Created by viveco on 2018/3/14.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "YSWaterWaveView.h"


@interface YSWaterWaveView ()

{
    CGFloat a;
    CGFloat w;
    CGFloat φ;
    CGFloat k;
    
    
    CGFloat viewHeight;
    CGFloat viewWidth;
    
    CGFloat speed;
    
    CADisplayLink *displayLink;
}



@end

@implementation YSWaterWaveView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}


#pragma mark - 初始化
- (void)initData {
    viewWidth = self.bounds.size.width;
    viewHeight = self.bounds.size.height;
    
    a = viewHeight/20;
    w = 2*M_PI/(viewWidth*0.9);
    
    speed = 0.08;
}

- (void)drawRect:(CGRect)rect {
//    [self drawStar];
    [self drawWave];
}



#pragma mark - 绘制波纹
- (void)drawWave {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    for (CGFloat x = 0.0; x <= viewWidth; x ++) {
        CGFloat y = a*sin(w*x + φ) + (1-_progress)*(viewHeight + 2*a);
        if (x == 0) {
            //起始点
            [path moveToPoint:CGPointMake(x, y - a)];
        } else {
            [path addLineToPoint:CGPointMake(x, y - a)];
        }
    }
    //闭合path
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
    [path addLineToPoint:CGPointMake(0, viewHeight)];
    [path closePath];
    
    [[UIColor redColor] setFill];
    [path fill];
}


#pragma mark - animation
- (void)waveAnimation {

    φ += speed;
    [self setNeedsDisplay];
}


-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)dealloc {
    [displayLink invalidate];
    displayLink = nil;
}

@end
