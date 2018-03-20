//
//  NGRViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/20.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "NGRViewController.h"

@interface NGRViewController ()
{
    NSTimer * timer;
}
@end

@implementation NGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self somethingNSTimer];
}

- (void)somethingNSTimer{
    
    timer = [NSTimer timerWithTimeInterval:0.032 target:self selector:@selector(changeImg) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)changeImg{
    
}
@end
