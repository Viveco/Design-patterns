//
//  XNetTool.h
//  NewCenterWeather
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.

#import <UIKit/UIKit.h>
#import "NTCacheTool.h"


NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nullable (^NTNetToolGlobalBaseURLBlock)(NSString *subURL);
typedef NSDictionary * _Nullable (^NTNetToolGlobalBaseParamsBlock)(NSString *url, NSDictionary *subParams);
typedef id _Nullable (^NTNetToolGlobalResponseHandleBlock)(NSString *url, id responseObject);


typedef NS_ENUM(NSUInteger, NTNetStatusType) {
    NTNetStatusTypeUnKnown          = -1,
    NTNetStatusTypeNotReachable      = 0,
    NTNetStatusTypeWWAN             = 1,
    NTNetStatusTypeWIFI             = 2,
};

typedef NS_ENUM(NSUInteger, NTNetCacheType) {
    NTNetCacheTypeNone = 0,     //不进行接口缓存
    NTNetCacheTypeIngorCache,   //忽略缓存，直接请求，但会缓存接口
    NTNetCacheTypeUseCahceFirst,  //有缓存则只取缓存，不请求，否者才请求数据并缓存接口
    NTNetCacheTypeUseCacheAndRequst //优先读取缓存，同时进行网络请求，并缓存接口
};

@interface NTNetTool : NSObject

/**是否需要取消上一次的网络请求*/
@property (nonatomic, assign) BOOL needCancleLastRequest;
/**3840错误解决*/
@property (nonatomic, assign) BOOL support3840;
/**常见text/html不支持错误解决*/
@property (nonatomic, assign) BOOL supportTextHtml;
/**手动设置contentType*/
@property (nonatomic, copy) NSString *supportcontentType;
/**请求头*/
@property (nonatomic, copy) NSDictionary *requestHeader;
/**超时时间， 默认15秒*/
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/**忽略设置全局baseURL*/
@property (nonatomic) BOOL ignorGlobalBaseURL;
/**忽略设置全局baseParams*/
@property (nonatomic) BOOL ignorGlobalBaseParams;
/**忽略设置全局responseHandle*/
@property (nonatomic) BOOL ignorGlobalResponseHandle;
/**忽略设置全局网络工具配置*/
@property (nonatomic) BOOL ignorGlobalNetToolConfig;
/**在此处可以对返回值进行处理*/
@property (nonatomic, copy) NTNetToolGlobalResponseHandleBlock responseHandleConfig;


/**
 获取全局的网络工具类，进行一些通用性的网络请求

 @return 全局网络工具类
 */
+ (NTNetTool *)nt_netTool;

/**
 获取网络状态
 
 @return 网络状态
 */
+ (NTNetStatusType)nt_getNetStatus;

#pragma mark - 缓存相关
/**
 获取默认的网络缓存工具，可以对其相关的配置，配置见NTCacheTool

 @return 缓存工具
 */
+ (NTCacheTool *)nt_netCacheTool;

/**
 自定义缓存工具，比如要将缓存保存在其它位置，或者有某些特殊设置，可以重新配置缓存工具类
 
 @param cacheTool 新的缓存工具
 */
- (void)nt_customNetCacheTool:(NTCacheTool *)cacheTool;

/**
 异步获取指定链接的缓存数据，缓存数据的存储是以url和params的组合作为key值

 @param urlString 对应的url
 @param params 对应的参数
 @param completion 获取后的回调
 */
- (void)nt_getCacheDataWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void(^)(id cacheData))completion;

/**
 同步获取指定链接的缓存数据

 @param urlString 对应的url
 @param params 对应的参数
 @return 获取的缓存数据
 */
- (id)nt_getCacheDataWithURL:(NSString *)urlString params:(NSDictionary *)params;

#pragma mark - 全局配置相关
/**
 添加全局的BaseURL，如果要排出某些url，比如某些url不需要BaseURL，请设置ignorGlobalBaseURL = YES

 @param urlConfig url配置Block
 */
+ (void)nt_setGlobalBaseURLConfig:(NTNetToolGlobalBaseURLBlock)urlConfig;

/**
 对参数进行全局配置，比如所有接口需要添加一些固定参数，就可以放在这里，如要忽略，请设置ignorGlobalBaseParams = YES；

 @param paramsConfig params配置Block
 */
+ (void)nt_setGlobalBaseParamsConfig:(NTNetToolGlobalBaseParamsBlock)paramsConfig;

/**
 对返回数据进行全局配置，比如所有的接口都有进行加密，可以在此处进行解密，并返回

 @param responseHandleConfig 返回数据配置Block
 */
+ (void)nt_setGlobalResponseHandleConfig:(NTNetToolGlobalResponseHandleBlock)responseHandleConfig;

/**
 对网络工具类进行全局配置，比如所有的网络工具类都需要有此设置，可以在此进行设置

 @param netToolConfig 配置Block
 */
+ (void)nt_setGlobalNetToolConfig:(void((^)(NTNetTool *netTool)))netToolConfig;

#pragma mark - 请求相关
/**
 发起GET请求
 */
- (void)nt_get:(NSString *)urlString params:(nullable NSDictionary *)params cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed;
/**
 发起POST请求
 */
- (void)nt_post:(NSString *)urlString params:(nullable NSDictionary *)params cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed;
/**
 发起SOAP请求
 */
- (void)nt_soap:(NSString *)urlString soapXMLString:(nullable NSString *)soapString cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed;
/**
 上传请求接口，上传NSData数据
 */
- (void)nt_upload:(NSString *)urlString params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type progress:(nullable void(^)(NSProgress * uploadProgress))progress successed:(void(^)(id object))successed failed:(void(^)(NSError * error))failed;
/**
 上传请求接口，上传本地文件
 */
- (void)nt_upload:(NSString *)urlString params:(NSDictionary *)params filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type progress:(nullable void(^)(NSProgress * uploadProgress))progress successed:(void(^)(id object))successed failed:(void(^)(NSError * error))failed;
/**
 下载请求接口
 */
- (NSURLSessionDownloadTask *)nt_download:(NSString *)urlString filePath:(nullable NSString *)filePath progress:(nullable void(^)(CGFloat progress))progress successed:(void(^)(NSURL *filePath))successed failed:(void(^)(NSError * error))failed;

/**
 取消当前网络工具下的所有请求
 */
- (void)nt_cancelAllRequest;

@end

extern NSString *const NTNetStatusDidChangeNotification;

NS_ASSUME_NONNULL_END
