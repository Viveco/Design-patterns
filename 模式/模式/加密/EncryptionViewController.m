//
//  EncryptionViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/3.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "EncryptionViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface EncryptionViewController ()

@end

@implementation EncryptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)MD5:(UIButton *)sender {
    NSLog(@"%@",[Encryption md5EncryptWithString:@"123"]);
}
- (IBAction)base64:(UIButton *)sender {
    NSLog(@"%@",[Encryption base64EncryptWithString:@"123"]);
}
- (IBAction)decodeBase64:(UIButton *)sender {
    NSLog(@"%@",[Encryption base64DecodeWithString:@"MTIz"]);
}
- (IBAction)localAuthentication:(UIButton *)sender {
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version< 8.0) {
        return;
    }
    LAContext * laCtx = [[LAContext alloc] init];
    if (![laCtx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        return;
    }
    [laCtx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登陆" reply:^(BOOL success, NSError *error) {
        // 如果成功,表示指纹输入正确.
        if (success) {
            NSLog(@"指纹识别成功!");

        } else {
            NSLog(@"指纹识别错误,请再次尝试");
        }
    }];
}
- (IBAction)AES:(UIButton *)sender {
   NSLog(@"%@",[AES encrypt:@"aaa" password:@"11111"]);
}
- (IBAction)decodeAES:(UIButton *)sender {
   NSLog(@"%@", [AES decrypt:@"mVgUtZKfFmb6u8JHcwOpuw==" password:@"11111"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end





@implementation Encryption
//秘钥
static NSString *encryptionKey = @"nha735n197nxn(N′568GGS%d~~9naei';45vhhafdjkv]32rpks;lg,];:vjo(&**&^)";


+ (NSString *)md5EncryptWithString:(NSString *)string{
    return [self MD5For32Bate:[NSString stringWithFormat:@"%@%@", encryptionKey, string] isSmall:NO];
}

+(NSString *)MD5For32Bate:(NSString *)str isSmall:(BOOL)issmall{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        if (issmall) {
            [digest appendFormat:@"%02x", result[i]];
        }else{
            [digest appendFormat:@"%02X", result[i]];
        }
    }
    return digest;
}


+ (NSString * )base64EncryptWithString:(NSString * )string{
    
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64Str = [data base64EncodedStringWithOptions:0];
    return base64Str;
}

+ (NSString * )base64DecodeWithString:(NSString * )string{
    
    NSData * data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString * decodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodeString;
}

//AES加密
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password{
    return [AES encrypt:message password:password];
}
//AES解密
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password{
    return [AES decrypt:base64EncodedString password:password];
}

//生成八位随机字符串
+ (NSString *)shuffledAlphabet {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:8];
    free(characters);
    return result;
}
@end

