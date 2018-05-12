//
//  UIAlertView+NTAdd.h
//  RedEnvelopes
//
//  Created by wazrx on 16/3/21.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NTAdd)

+(void)nt_showAlertViewWith:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle leftButtonClickedConfig:(dispatch_block_t)leftBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonClickedConfig:(dispatch_block_t)rightBlock;

+(void)nt_showOneAlertViewWith:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonClickedConfig:(dispatch_block_t)block;

@end
