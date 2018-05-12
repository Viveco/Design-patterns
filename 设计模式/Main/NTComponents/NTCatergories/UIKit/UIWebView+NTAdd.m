//
//  UIWebView+NTAdd.m
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIWebView+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

#import <objc/runtime.h>

NT_SYNTH_DUMMY_CLASS(UIWebView_NTAdd)

@implementation UIWebView (NTAdd)

//- (void)setLongPressConfig:(void (^)(BOOL, NSString *))longPressConfig{
//    [self nt_setAssociateCopyValue:longPressConfig withKey:"nt_longPressConfig"];
//}
//
//- (void (^)(BOOL, NSString *))longPressConfig{
//    return [self nt_getAssociatedValueForKey:"nt_longPressConfig"];
//}

+ (void)nt_customWebUserAgentAppendString:(NSString *)string {
    UIWebView *web = [self new];
    NSString *userAgent=[web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@",userAgent, string],
                                  @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}

//- (void)nt_enableLongPressGesture{
//    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(_nt_longGes:)];
//    longGesture.delegate = self;
//    [self addGestureRecognizer:longGesture];
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//-(void)_nt_longGes:(UILongPressGestureRecognizer * )longGes{
//    
//    if (longGes.state == UIGestureRecognizerStateBegan) {
//        CGPoint pt = [longGes locationInView:longGes.view];
//        CGPoint offset  = [self.scrollView contentOffset];
//        CGSize viewSize = self.bounds.size;
//        CGSize windowSize = NT_ROOT_WINDOW.bounds.size;
//        CGFloat f = windowSize.width / viewSize.width;
//        pt.x = pt.x * f + offset.x;
//        pt.y = pt.y * f + offset.y;
//        [self _nt_checkPoint:pt];
//    }
//}

//- (void)_nt_checkPoint:(CGPoint )point
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"txt"];
//    
//    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self stringByEvaluatingJavaScriptFromString: jsCode];
//    NSString *tags = [self stringByEvaluatingJavaScriptFromString:
//                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%zd,%zd);",(NSInteger)point.x,(NSInteger)point.y]];
//    NSString *nodeName = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).nodeName", point.x, point.y];
//    if ([nodeName isEqualToString:@"IMG"]) {
//        NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
//        NSString *imgURL = [self stringByEvaluatingJavaScriptFromString:str];
//        if (imgURL.length) {
//            NT_LOG(@"是图片, %@", imgURL);
//            NT_BLOCK(self.longPressConfig, YES, str);
//        }
//        return;
//    }
//    int i = 0;
//    NSString *url = nil;
//    do {
//        NSMutableString *formart = @"document.elementFromPoint(%f, %f)".mutableCopy;
//        for (int j = 0; j < i; j ++) {
//            [formart appendString:@".parentNode"];
//        }
//        NSString *str = [formart stringByAppendingString:@".nodeName"];
//        NSString *nodeName = [NSString stringWithFormat:str, point.x, point.y];
//        if ([nodeName isEqualToString:@"A"]) {
//            NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", point.x, point.y];
//            NSString *http = [self stringByEvaluatingJavaScriptFromString:str];
//            if (http.length) {
//                NT_LOG(@"是url, %@", http);
//                url = http;
//            }
//        }
//        
//    } while (i > 10 || url);
//    NT_BLOCK(self.longPressConfig, YES, url);
//}

@end
