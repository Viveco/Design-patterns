//
//  UIViewController+NTAdd.m
//  XWPhotoPicker
//
//  Created by wazrx on 16/8/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIViewController+NTAdd.h"
#import "NTCategoriesMacro.h"
#import "NSObject+NTAdd.h"

NT_SYNTH_DUMMY_CLASS(UIViewController_NTAdd)

@implementation UIViewController (NTAdd)



- (BOOL)isViewVisible{
    return [self isViewLoaded] && [[self view] window] != nil;
}

@end
