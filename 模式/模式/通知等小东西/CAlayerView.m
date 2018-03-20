//
//  CAlayerView.m
//  设计模式
//
//  Created by viveco on 2018/3/13.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "CAlayerView.h"

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@implementation CAlayerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setValue:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1] forKey:@"backgroundColor"];
        [self initSubView];
    }return self;
}

- (void)initSubView{
    
    CALayer * layer = [CALayer layer];

    layer.frame = G_R(160, 100, 100,100);
//    layer.position = G_P(35, 55);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;
    layer.contents = CFBridgingRelease([UIImage imageNamed:@"11.png"].CGImage);
    layer.shadowColor = [UIColor blueColor].CGColor;
    layer.opacity = 0.7; // 类似 alpha

    [self.layer addSublayer:layer];
    
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    layer.position = G_P(100, 100);
    [CATransaction commit];
}

//// 什么时候调用
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//
//    CGContextSetRGBFillColor(ctx, 0.8, 0.8, 0.8, 1);
//    CGContextSetLineWidth(ctx, 4);
//    CGContextAddRect(ctx, layer.bounds);
//    CGContextStrokePath(ctx);
//}


@end
