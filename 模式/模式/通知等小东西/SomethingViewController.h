//
//  SomethingViewController.h
//  设计模式
//
//  Created by viveco on 2018/3/5.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTestView.h"
#import "Quartz2DView.h"


@class ValueForKey;
@protocol SomethingVCDelegate <NSObject>

@required
- (void)tellSomethingAbout:(NSString * )something;

@optional
- (void)thisIsDelegate;

@end

@interface SomethingViewController : UIViewController

@property (weak, nonatomic) id<SomethingVCDelegate> delegate;

@end


@interface ValueForKey : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *grade;

@end
