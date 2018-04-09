//
//  EncryptionViewController.h
//  设计模式
//
//  Created by viveco on 2018/4/3.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AES.h"

@class Encryption;
@interface EncryptionViewController : UIViewController

@end




@interface Encryption : NSObject

+ (NSString *)shuffledAlphabet;

//md5加密方法
+ (NSString *)md5EncryptWithString:(NSString *)string;

//base64加密
+ (NSString * )base64EncryptWithString:(NSString * )string;
//base64解密
+ (NSString * )base64DecodeWithString:(NSString * )string;

//AES加密
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
//AES解密
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;



@end
