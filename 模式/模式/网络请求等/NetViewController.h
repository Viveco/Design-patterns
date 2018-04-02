//
//  NetViewController.h
//  设计模式
//
//  Created by viveco on 2018/3/28.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemInfo;
@interface NetViewController : UIViewController


@property (strong, nonatomic) ItemInfo *testItem;

@end





@interface ItemInfo : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) float weight;

// 使用过的次数
@property (nonatomic, assign) NSUInteger usedTimes;

// 尺寸
@property (nonatomic, assign) CGRect size;

-(void)selector;


@end
