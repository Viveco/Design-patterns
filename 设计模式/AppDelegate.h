//
//  AppDelegate.h
//  设计模式
//
//  Created by 罗罗明祥 on 2017/12/5.
//  Copyright © 2017年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

