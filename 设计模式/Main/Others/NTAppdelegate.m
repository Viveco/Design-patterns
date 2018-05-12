//
//  AppDelegate.m
//  NTWeather
//
//  Created by 肖文 on 2017/9/20.
//  Copyright © 2017年 NinetonTech. All rights reserved.
//

#import "NTAppdelegate.h"

#import "NTHomeController.h"

#import "NTCatergory.h"

@interface NTAppdelegate ()

@end

@implementation NTAppdelegate

#pragma mark - Lazyloading Methods
- (UIWindow *)window{
    if (!_window) {
        _window = [UIWindow new];
        _window.frame = NT_SCREEN_BOUNDS;
        [_window makeKeyAndVisible];
    }
    return _window;
}

#pragma mark - Application Cycle Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [NTHomeController new];
    return YES;
}

@end
