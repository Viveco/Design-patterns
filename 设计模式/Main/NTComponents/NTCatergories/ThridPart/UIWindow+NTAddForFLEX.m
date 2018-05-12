//
//  UIWindow+XWAddForFLEX.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/6/1.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "UIWindow+NTAddForFLEX.h"
#if DEBUG
#import <FLEX/FLEX.h>
#endif

@implementation UIWindow (NTAddForFLEX)

#if DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[FLEXManager sharedManager] showExplorer];
        
    }
}
#endif

@end
