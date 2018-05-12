//
//  NTOnlineConfigTool.m
//  weather+
//
//  Created by wazrx on 16/4/26.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTOnlineConfigTool.h"
#import "NTCategoriesMacro.h"
#import "NTDataTool.h"
#import "NTNetTool.h"
#import "NSNotificationCenter+NTAdd.h"
#import <objc/runtime.h>

static NSString *const kTJBaseURL = @"https://tj.nineton.cn/Api/Config/g?appid=%@&cid=%@";
static NSString *const kTJID = @"com.nineton.newcenterweather.onlinetool.tjid";

@interface NTOnlineConfigTool ()<NSURLSessionDelegate>

@end

@implementation NTOnlineConfigTool
static BOOL kOnlineConfigUpdatedFlag = NO;

+ (void)nt_registerTJOnlineConfigWithTJID:(NSString *)tjID {
    if (!tjID.length) return;
    kOnlineConfigUpdatedFlag = NO;
    objc_setAssociatedObject(self, &kTJID, tjID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [NT_NOTIFICATION_CENTER nt_addNotificationForName:NTNetStatusDidChangeNotification block:^(NSNotification * _Nonnull notification) {
        if (kOnlineConfigUpdatedFlag || [NTNetTool nt_getNetStatus] == NTNetStatusTypeNotReachable) return;
        [self nt_updateOnlineConfigBySyncTimeout:0];
    }];
}

+ (void)nt_updateOnlineConfigBySyncTimeout:(NSTimeInterval)syncTimeoutInterval{
    if (kOnlineConfigUpdatedFlag) return;
    NSString *tjID = objc_getAssociatedObject(self, &kTJID);
    if (!tjID.length) {
        NT_LOG(@"⚠️缺少TJID，请先注册");
        return;
    };
    NSString *urlString = [NSString stringWithFormat:@"http://tj.nineton.cn/Api/Config/appconfig?appid=%@", tjID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (syncTimeoutInterval) {
        config.timeoutIntervalForRequest = syncTimeoutInterval;
    }
    __block NTOnlineConfigTool *delegateTool = [NTOnlineConfigTool new];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:delegateTool delegateQueue:nil];
    dispatch_semaphore_t semaphore;
    if (syncTimeoutInterval) {
         semaphore = dispatch_semaphore_create(0);
    }
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            delegateTool = nil;
            if (syncTimeoutInterval) {
                dispatch_semaphore_signal(semaphore);
            }
            return;
        };
        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray<NSDictionary *> *data = NTValidateArray(obj[@"data"]);
            [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj = NTValidateDict(obj);
                NSString *cid = NTValidateString(obj[@"cid"]);
                NSString *content = NTValidateString(obj[@"content"]);
                if (cid.length && content.length) {
                    [[NSUserDefaults standardUserDefaults] setObject:content forKey:cid];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    kOnlineConfigUpdatedFlag = YES;
                    delegateTool = nil;
                    if (syncTimeoutInterval) {
                        dispatch_semaphore_signal(semaphore);
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:NTTjOnlineConfigDidUpdateNotification object:nil];
                        });
                    }
                }
            }];
        });
    }];
    [task resume];
    if (syncTimeoutInterval) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}


+ (void)_nt_saveOnlineConfig:(NSData *)data key:(NSString *)key{
    if (!key.length || !data) return;
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *content = obj[@"content"];
    if (content) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", content] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (NSString *)nt_getOnlineConfigWithKey:(NSString *)key {
    if (!key.length)return nil;
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return result;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

NSString *const NTTjOnlineConfigDidUpdateNotification = @"com.nineton.tjonlineconfig.onlineConfigDidUpdateNotification";

@end
