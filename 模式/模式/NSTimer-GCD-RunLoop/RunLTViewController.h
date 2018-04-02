//
//  RunLTViewController.h
//  设计模式
//
//  Created by viveco on 2018/3/26.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RuntimerModel;

@interface RunLTViewController : UIViewController

@end

@protocol RuntimeModelDelegate <NSObject>

- (void)NameAgeSexHobby;

@end

@interface RuntimeModel : NSObject

@property (readonly,strong, nonatomic,) NSArray *hobbyAr;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;
@property (copy, nonatomic) NSString *sex;

- (NSString * )isName;

- (NSInteger)isAge;

- (NSString * )isSex;

+ (void)NameAge;


@end


