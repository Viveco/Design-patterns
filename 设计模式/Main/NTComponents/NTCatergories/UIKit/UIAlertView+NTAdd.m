//
//  UIAlertView+NTAdd.m
//  RedEnvelopes
//
//  Created by wazrx on 16/3/21.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIAlertView+NTAdd.h"
#import "NSObject+NTAdd.h"
#import <objc/runtime.h>
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIAlertView_NTAdd)

@interface _NTAlertDelegateObject : NSObject<UIAlertViewDelegate>

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;

+ (instancetype)nt_initWithLeftBlock:(dispatch_block_t)leftBlock rightBlock:(dispatch_block_t)rightBlock;

@end

@implementation _NTAlertDelegateObject

+ (instancetype)nt_initWithLeftBlock:(dispatch_block_t)leftBlock rightBlock:(dispatch_block_t)rightBlock{
    _NTAlertDelegateObject *obj = [_NTAlertDelegateObject new];
    obj.leftBlock = leftBlock;
    obj.rightBlock = rightBlock;
    return obj;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_leftBlock && buttonIndex == 0) {
        _leftBlock();
        return;
    }
    if (_rightBlock && buttonIndex == 1) {
        _rightBlock();
        return;
    }
}

@end

@implementation UIAlertView (NTAdd)

+(void)nt_showAlertViewWith:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle leftButtonClickedConfig:(dispatch_block_t)leftBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonClickedConfig:(dispatch_block_t)rightBlock{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:leftButtonTitle, rightButtonTitle, nil];
    _NTAlertDelegateObject *obj = [_NTAlertDelegateObject nt_initWithLeftBlock:leftBlock rightBlock:rightBlock];
    alertView.delegate = obj;
    [alertView nt_setAssociateValue:obj withKey:"_NTAlertDelegateObject"];
    [alertView show];
}

+ (void)nt_showOneAlertViewWith:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonClickedConfig:(dispatch_block_t)block{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:buttonTitle, nil];
    _NTAlertDelegateObject *obj = [_NTAlertDelegateObject nt_initWithLeftBlock:block rightBlock:nil];
    alertView.delegate = obj;
    [alertView nt_setAssociateValue:obj withKey:"_NTAlertDelegateObject"];
    [alertView show];
}

@end
