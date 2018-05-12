//
//  UIWebView+NTAdd.h
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (NTAdd)<UIGestureRecognizerDelegate>
//@property (nonatomic, copy) void(^longPressConfig)(BOOL isImage, NSString *url);
+ (void)nt_customWebUserAgentAppendString:(NSString *)string;

//- (void)nt_enableLongPressGesture;
@end
