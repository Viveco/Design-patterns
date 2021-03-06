//
//  Quartz2DView.m
//  设计模式
//
//  Created by viveco on 2018/3/9.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "Quartz2DView.h"

@implementation Quartz2DView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setValue:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1] forKey:@"backgroundColor"];
        [self.layer display];
    
    }return self;
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();


    // 裁剪
//    CGContextMoveToPoint(ctx, 10, 10);
//    CGContextAddLineToPoint(ctx, 10, 90);
//    CGContextAddLineToPoint(ctx, 90, 90);
//    CGContextAddLineToPoint(ctx, 90, 10);
//    CGContextClosePath(ctx);
//    CGContextClip(ctx);
//

    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextMoveToPoint(ctx, 10, 10);
    CGContextAddLineToPoint(ctx, 150, 150);
    CGContextAddLineToPoint(ctx, 10, 150);
    CGContextAddLineToPoint(ctx, 10, 10);
    CGContextSetLineWidth(ctx, 5);

    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);

    // 两个控制点
    CGContextMoveToPoint(ctx, 100, 100);
    CGContextAddCurveToPoint(ctx, 300,250, 300, 50, 150, 150);
    CGContextStrokePath(ctx);

    //一个控制点
    CGContextMoveToPoint(ctx, 300, 300);
    CGContextAddQuadCurveToPoint(ctx, 200, 200, 300, 150);
    CGContextStrokePath(ctx);

    // 画圆
    CGContextAddArc(ctx, 175, 175, 30, 0, M_PI * 2 , 0);
    CGContextStrokePath(ctx);

    // 虚线

    CGFloat lengths[] = {10,5};
    CGContextSetLineDash(ctx, 0, lengths, 2);//画虚线
    CGContextMoveToPoint(ctx, 10, 70);//开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(ctx, 310, 70);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(ctx);//开始画线



//    CGContextTranslateCTM(ctx, 100, 0);
//    CGContextRotateCTM(ctx, 0.2);
//    CGContextScaleCTM(ctx, 1, 1);
    // 椭圆
    CGContextAddRect(ctx, CGRectMake(10, 200, 100, 120));
    CGContextAddEllipseInRect(ctx, CGRectMake(10, 200, 100, 120));
    CGContextDrawPath(ctx, kCGPathStroke);

    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 300, 100, 100) cornerRadius:50];
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);

    [self drawString];
}

- (void)drawString{


    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    UIFont *textFont = [UIFont systemFontOfSize:16];
    
    NSString *text = @"Lorem ipsum";
    
    [text drawInRect:CGRectMake(0, 400, 100, 100) withAttributes:@{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:textStyle}];

}

@end
