//
//  NTOnlineConfigTool.h
//  weather+
//
//  Created by wazrx on 16/4/26.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+NTAdd.h"
#import "NTDataTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface NTOnlineConfigTool : NSObject

/**
 注册在线参数，该接口会注册网络变化通知，如果在网络变化后发现在线参数还未成功请求，会自动请求在线参数，你可以进行监听NTTjOnlineConfigDidUpdateNotification；

 @param tjID 应用ID
 */
+ (void)nt_registerTJOnlineConfigWithTJID:(NSString *)tjID;


/**
 更新所有的在线参数，可选择是否以同步的方式更新，但建议不要使用同步模式，会造成App启动时间增加，可以通过注册在线参数刷新的notification来获取在线参数的刷新点

 @param syncTimeoutInterval 同步请求的超时时间，如果选择同步更新则传入时间，否则则异步更新在线参数
 */
+ (void)nt_updateOnlineConfigBySyncTimeout:(NSTimeInterval)syncTimeoutInterval;

/**
 *  获取指定key的在线参数
 */
+ (NSString *)nt_getOnlineConfigWithKey:(NSString *)key;

@end


static inline NSString *NTTjValueByKey(NSString *key){
    return [NTOnlineConfigTool nt_getOnlineConfigWithKey:key];
}


static inline NSString *NTTjValueByKeyWithDefaultValue(NSString *key, NSString *defaultValue){
    NSString *value = [NTOnlineConfigTool nt_getOnlineConfigWithKey:key];
    return value.length ? value : defaultValue;
}


// 在线参数拉取成功的通知
extern NSString *const NTTjOnlineConfigDidUpdateNotification;

NS_ASSUME_NONNULL_END
