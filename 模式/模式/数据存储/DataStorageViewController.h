//
//  DataStorageViewController.h
//  设计模式
//
//  Created by viveco on 2018/4/17.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ValueForKey;

@interface DataStorageViewController : UIViewController

@end



@interface ValueForKey : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *grade;
@property (strong, nonatomic) NSArray *dataArray;

@end
