//
//  AnimationVC.m
//  设计模式
//
//  Created by viveco on 2018/2/28.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "AnimationVC.h"
#import "YSWaterWaveView.h"


@interface AnimationVC ()<UIScrollViewDelegate,CAAnimationDelegate>

@property (strong, nonatomic) UIButton *animationBT;
@property (strong, nonatomic) YSWaterWaveView * waveView;

@end

@implementation AnimationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.animationBT];
    
    [self waveViewAnimation];
//    [self CABasicAnimation];
//    [self CAkeyframeAnimation];
//    [self CAAnimationGroup];
//    [self CATransition];
}

#pragma mark -- 简单水波动画等
- (void)waveViewAnimation{
    
    YSWaterWaveView * view = [[YSWaterWaveView alloc] initWithFrame:CGRectMake(10,100, 150, 150)];
    self.waveView = view;
    [self.view addSubview:self.waveView];
}


- (void)CABasicAnimation{
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 3.0f;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 300)];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
//    animation.byValue =[NSValue valueWithCGPoint:CGPointMake(100, 500)];// 添加量
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = NO; // 在执行一次动画，只不过是原来样子倒着执行一次
//    animation.repeatDuration = 3; // 如果重复，则重复的时间
    animation.beginTime = CACurrentMediaTime();// 每次动画 什么时候开始
    animation.delegate = self;
    [self.animationBT.layer addAnimation:animation forKey:@"CABasicAnimation"];
}

- (void)CAkeyframeAnimation{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(10, 150)],[NSValue valueWithCGPoint:CGPointMake(300, 150)],[NSValue valueWithCGPoint:CGPointMake(100, 250)]];
    animation.duration = 10;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
//    animation.calculationMode = kCAAnimationPaced; // 特有属性，添加平滑 这个属性会自动分配时间，所以设置keyTimes的时候就注释吧
    animation.keyTimes = @[@0, @0.1, @0.4, @0.9, @1];
    animation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 150, 300)].CGPath;// 添加路径然后 values 就被忽略了
    animation.repeatCount = MAXFLOAT;
    animation.rotationMode = kCAAnimationRotateAuto; // 引发自动旋转
    [self.animationBT.layer addAnimation:animation forKey:@"CAKeyframeAnimation"];
}

- (void)CAAnimationGroup{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(100, 100)],[NSValue valueWithCGPoint:CGPointMake(0, 200)]];
    animation.duration = 2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.keyTimes = @[@0,@0.25,@0.5,@0.75,@1];
    animation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 300)].CGPath;
    
    CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation2.toValue = @20;
    animation2.duration = 2;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.duration = 2;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[animation,animation2];
    group.repeatCount = MAXFLOAT;
    [self.animationBT.layer addAnimation:group forKey:@"group"];
    NSLog(@"%@",NSStringFromClass([group class]));
    NSClassFromString(@"CAAnimationGroup");
}

- (void)CATransition{
   
    CATransition *animation = [CATransition animation];
    animation.duration = 5;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.animationBT.layer addAnimation:animation forKey:@"ripple"];
    [self.animationBT setBackgroundImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];;
    
}

#pragma mark --  CADisplayLink

- (void)CADisplayLink{
    
    CADisplayLink * displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinnk)];
    displaylink.paused = YES;
    displaylink.preferredFramesPerSecond = 2;
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)displayLinnk{
  
}
#pragma mark --Getter

- (UIButton *)animationBT{
    if (!_animationBT) {
        _animationBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _animationBT.backgroundColor = [UIColor yellowColor];
        _animationBT.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_animationBT setTitle:@"动画效果" forState:UIControlStateNormal];
        _animationBT.frame = CGRectMake(200, 100, 100, 100);
        _animationBT.layer.borderWidth =3;
        _animationBT.layer.borderColor = [UIColor grayColor].CGColor;
        [_animationBT addTarget:self action:@selector(CATransition) forControlEvents:UIControlEventTouchUpInside];
        [_animationBT setBackgroundImage:[UIImage imageNamed:@"qwer.png"] forState:UIControlStateNormal];;
    }return _animationBT;
}
- (void)handleFailure{
    self.waveView.progress += 0.1;
}
@end


