//
//  SKUViewController.h
//  设计模式
//
//  Created by viveco on 2018/1/23.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIButtonPQBackgroundColor;
@interface SKUViewController : UIViewController


@end

@interface UIButton (PQBackgroundColor)

- (void)pq_setBackgroundColor:(UIColor *)color state:(UIControlState)state;

@end

