//
//  SomethingViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/5.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "SomethingViewController.h"

@interface SomethingViewController ()

@end

@implementation SomethingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self somethingNote];
    
}
- (void)somethingNote{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle:) name:@"xc" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xc" object:@[@"xinyu"] userInfo:@{@"德玛":@"西亚"}];
    
    NSNotification * notification = [NSNotification notificationWithName:@"dema" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handle:(NSNotification * )note{
    NSLog(@"%@",note.object);
    
}

- (void)keyboard:(NSNotification * )note{
     CGRect frame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    
    // 可以定义位置然后 layoutIfNeeded
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
