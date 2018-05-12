//
//  XNetTool.m
//  NewCenterWeather
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "NTNetTool.h"
#import "NTCategoriesMacro.h"
#import "NSDictionary+NTAdd.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

static NTCacheTool *netCacheTool;
static NTNetTool *netTool;
static NTNetToolGlobalBaseURLBlock globalBaseURLConfig;
static NTNetToolGlobalBaseParamsBlock globalBaseParamsConfig;
static NTNetToolGlobalResponseHandleBlock globalResponseHandleConfig;
static void(^globalNetToolConfig) (NTNetTool *netTool);

__attribute__((constructor))
static void _NTStartMonitoringNetStatus(){
    NT_LOG(@"开启网络监听,初始化网络缓存工具");
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    netCacheTool = [NTCacheTool nt_cacheToolWithType:NTCacheToolTypeMemoryAndDisk name:@"com.nineton.xwnettool.netcache"];
    netCacheTool.shouldRemoveAllObjectsOnMemoryWarning = YES;
    netCacheTool.shouldRemoveAllObjectsWhenEnteringBackground = NO;
}

@implementation NTNetTool{
    NSURLSessionDataTask *_lastTask;
    dispatch_semaphore_t _semaphore;
    NTCacheTool *_cacheTool;
    AFHTTPSessionManager *_manager;
    AFURLSessionManager *_downLoadManager;
    NTNetCacheType _cacheType;
    AFHTTPResponseSerializer<AFURLResponseSerialization> *_defalutResponseSerializer;
    AFHTTPRequestSerializer<AFURLRequestSerialization> *_defalutRequestSerializer;
    
}

- (void)dealloc{
    [_manager.session invalidateAndCancel];
    [_downLoadManager.session invalidateAndCancel];
}

+ (NTNetTool *)nt_netTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netTool = [NTNetTool new];
    });
    return netTool;
}

+ (NTCacheTool *)nt_netCacheTool{
    return netCacheTool;
}

+ (void)nt_setGlobalBaseURLConfig:(NTNetToolGlobalBaseURLBlock)urlConfig{
    globalBaseURLConfig = urlConfig;
}

+ (void)nt_setGlobalBaseParamsConfig:(NTNetToolGlobalBaseParamsBlock)paramsConfig{
    globalBaseParamsConfig = paramsConfig;
}

+ (void)nt_setGlobalResponseHandleConfig:(NTNetToolGlobalResponseHandleBlock)responseHandleConfig{
    globalResponseHandleConfig = responseHandleConfig;
}

+ (void)nt_setGlobalNetToolConfig:(void ((^)(NTNetTool * _Nonnull)))netToolConfig{
    globalNetToolConfig = netToolConfig;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _defalutRequestSerializer = _manager.requestSerializer;
        _defalutResponseSerializer = _manager.responseSerializer;
        [_manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
            [session invalidateAndCancel];
        }];
        _downLoadManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [_downLoadManager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
            [session invalidateAndCancel];
        }];
        _semaphore = dispatch_semaphore_create(1);
        _timeoutInterval = 15;
        
        _manager.securityPolicy = [self _nt_customSecurityPolicy];
        _downLoadManager.securityPolicy = [self _nt_customSecurityPolicy];
    }
    return self;
}

- (void)nt_customNetCacheTool:(NTCacheTool *)cacheTool{
    _cacheTool = cacheTool;
    cacheTool.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cacheTool.shouldRemoveAllObjectsWhenEnteringBackground = NO;
}

- (NTCacheTool *)_nt_netCacheTool{
    return _cacheTool ?: netCacheTool;
}

- (AFSecurityPolicy *)_nt_customSecurityPolicy
{
    AFSecurityPolicy *securitypolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securitypolicy setAllowInvalidCertificates:YES];
    [securitypolicy setValidatesDomainName:NO];
    return securitypolicy;
}

+ (NTNetStatusType)nt_getNetStatus{
    return (NTNetStatusType)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

- (void)nt_cancelAllRequest{
    [_manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

- (void)nt_get:(NSString *)urlString params:(nullable NSDictionary *)params cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed {
    urlString = [self _nt_checkURLString:urlString];
    params = [self _nt_checkParams:urlString subParams:params];
    _cacheType = cacheType;
    NT_WEAKIFY(self);
    [self _nt_checkCacheUrl:urlString params:params cacheType:cacheType successed:successed requsetConfig:^{
        NT_STRONGIFY(self);
        [self _nt_get:urlString params:params success:successed fail:failed];
    }];
}

- (void)nt_post:(NSString *)urlString params:(nullable NSDictionary *)params cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed {
    urlString = [self _nt_checkURLString:urlString];
    params = [self _nt_checkParams:urlString subParams:params];
    _cacheType = cacheType;
    NT_WEAKIFY(self);
    [self _nt_checkCacheUrl:urlString params:params cacheType:cacheType successed:successed requsetConfig:^{
        NT_STRONGIFY(self);
        [self _nt_post:urlString params:params success:successed fail:failed];
    }];
    
}

- (void)nt_soap:(NSString *)urlString soapXMLString:(nullable NSString *)soapString cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed failed:(void(^)(NSError * error))failed {
    urlString = [self _nt_checkURLString:urlString];
    _cacheType = cacheType;
    NT_WEAKIFY(self);
    [self _nt_checkCacheUrl:[urlString stringByAppendingString:soapString] params:nil cacheType:cacheType successed:successed requsetConfig:^{
        NT_STRONGIFY(self);
        [self _nt_soap:urlString soapXMLString:soapString success:successed fail:failed];
    }];
}

- (void)nt_upload:(NSString *)urlString params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type progress:(void(^)(NSProgress * uploadProgress))progress successed:(void(^)(id object))successed failed:(void(^)(NSError * error))failed{
    _support3840 = YES;
    _supportTextHtml = YES;
    urlString = [self _nt_checkURLString:urlString];
    params = [self _nt_checkParams:urlString subParams:params];
    if (![self _nt_preparRequesetWithURL:urlString faileConfig:failed]) return;
    NT_WEAKIFY(self);
    _lastTask = [_manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data) {
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NT_BLOCK(progress, uploadProgress);
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NT_STRONGIFY(self);
        NT_BLOCK(successed, [self _nt_checkResponseObject:responseObject url:urlString]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NT_BLOCK(failed,error);
    }];
    [_lastTask resume];
}

- (void)nt_upload:(NSString *)urlString params:(NSDictionary *)params filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type progress:(void(^)(NSProgress * uploadProgress))progress successed:(void(^)(id object))successed failed:(void(^)(NSError * error))failed{
    urlString = [self _nt_checkURLString:urlString];
    params = [self _nt_checkParams:urlString subParams:params];
    if (![self _nt_preparRequesetWithURL:urlString faileConfig:failed]) return;
    NT_WEAKIFY(self);
    _lastTask = [_manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (filePath.length > 0) {
            NSError *error;
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:type error:&error];
            if (error) {
                NT_LOG(@"%@",error);
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NT_BLOCK(progress, uploadProgress);
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NT_STRONGIFY(self);
        NT_BLOCK(successed, [self _nt_checkResponseObject:responseObject url:urlString]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NT_BLOCK(failed,error);
    }];
    [_lastTask resume];
}


- (NSURLSessionDownloadTask *)nt_download:(NSString *)urlString filePath:(NSString *)filePath progress:(void(^)(CGFloat progress))progress successed:(void(^)(NSURL *filePath))successed failed:(void(^)(NSError * error))failed {
    NSAssert(urlString.length, @"url不能为空");
    if ([NTNetTool nt_getNetStatus] == NTNetStatusTypeNotReachable) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:@{@"CodeDes" : @"网络似乎已经断开链接"}];
        NT_BLOCK(failed, error);
        return nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downLoadTask = [_downLoadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NT_BLOCK(progress, 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = filePath ?: [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (error.code != -999) {
                NT_BLOCK(failed, error);
            };
            return;
        }
        NT_BLOCK(successed, filePath);
    }];
    [downLoadTask resume];
    return downLoadTask;
}

- (void)nt_getCacheDataWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void(^)(id))completion{
    urlString = [self _nt_checkURLString:urlString];
//    params = [[NTNetTool nt_netTool] _nt_checkParams:urlString subParams:params];
    [self _nt_searchCache:urlString params:params searchResultConfig:^(id cacheObject) {
        if (cacheObject) {
            NT_BLOCK(completion, cacheObject);
        }
    }];
}

- (id)nt_getCacheDataWithURL:(NSString *)urlString params:(NSDictionary *)params{
    urlString = [[NTNetTool nt_netTool] _nt_checkURLString:urlString];
//    params = [[NTNetTool nt_netTool] _nt_checkParams:urlString subParams:params];
    NSString *cacheKey = [netTool _nt_getCacheKeyWithUrl:urlString params:params];
    id obj = nil;
    if (cacheKey) {
        obj = [[self _nt_netCacheTool] nt_objectForKey:cacheKey];
    }
    return obj;
}


- (void)_nt_get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id object, BOOL isCache))success fail:(void(^)(NSError * error))fail{
    if (![self _nt_preparRequesetWithURL:url faileConfig:fail]) return;
    NT_WEAKIFY(self);
    _lastTask = [_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NT_STRONGIFY(self);
        NSMutableDictionary *temp = [responseObject mutableCopy];
        [self _nt_getDataSuccessedWithResponseObject:temp url:url params:params successed:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NT_STRONGIFY(self);
        if (error.code != -999) {
            [self _nt_getDataFailedWithError:error failed:fail];
        }
    }];
    [_lastTask resume];
}

- (void)_nt_post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id object, BOOL isCache))success fail:(void(^)(NSError * error))fail{
    if (![self _nt_preparRequesetWithURL:url faileConfig:fail]) return;
    NT_WEAKIFY(self);
    _lastTask = [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NT_STRONGIFY(self);
        [self _nt_getDataSuccessedWithResponseObject:responseObject url:url params:params successed:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NT_STRONGIFY(self);
        if (error.code != -999) {
            [self _nt_getDataFailedWithError:error failed:fail];
        }
    }];
    [_lastTask resume];
}

- (void)_nt_soap:(NSString *)url soapXMLString:(nullable NSString *)soap success:(void(^)(id object, BOOL isCache))success fail:(void(^)(NSError * error))fail {
    if (![self _nt_preparRequesetWithURL:url faileConfig:fail]) return;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[soap dataUsingEncoding:NSUTF8StringEncoding]];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NT_WEAKIFY(self);
    _lastTask = [_manager dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:^( NSURLResponse *response, id responseObject, NSError *error){
                                NT_STRONGIFY(self);
                                if (error) {
                                    if (error.code != -999) {
                                        [self _nt_getDataFailedWithError:error failed:fail];
                                    }
                                }else{
                                    [self _nt_getDataSuccessedWithResponseObject:responseObject url:[url stringByAppendingString:soap] params:nil successed:success];
                                }
                            }];
    [_lastTask resume];
}

- (void)_nt_mangerConfig{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (!_ignorGlobalNetToolConfig && globalNetToolConfig) NT_BLOCK(globalNetToolConfig, self);
    if (_needCancleLastRequest) {
        [_lastTask cancel];
    }
    if (_supportcontentType) {
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:_supportcontentType];
    }
    if (_support3840) {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else{
        _manager.responseSerializer = _defalutResponseSerializer;
        _manager.requestSerializer = _defalutRequestSerializer;
    }
    if (_supportTextHtml) {
        NSMutableSet *orgSet = [NSMutableSet setWithSet:_manager.responseSerializer.acceptableContentTypes];
        [orgSet addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = orgSet;
    }
    if (_requestHeader.count) {
        NSMutableDictionary *headers = [_manager.requestSerializer valueForKey:@"mutableHTTPRequestHeaders"];
        [headers removeObjectsForKeys:_requestHeader.allKeys];
        [headers addEntriesFromDictionary:_requestHeader];
    }
    _manager.requestSerializer.timeoutInterval = _timeoutInterval;
    dispatch_semaphore_signal(_semaphore);
}

- (void)_nt_saveCache:(NSString *)url params:(NSDictionary *)params value:(id)object{
    if (!object || ![self _nt_netCacheTool] || _cacheType == NTNetCacheTypeNone) return;
    NSString *key = [self _nt_getCacheKeyWithUrl:url params:params];
    if (!key.length) return;
    [[self _nt_netCacheTool] nt_setObject:object forKey:key];
}

- (NSString *)_nt_getCacheKeyWithUrl:(NSString *)url params:(NSDictionary *)params{
    NSMutableString *temp = url.mutableCopy;
    NSDictionary *globalP;
    if (globalBaseParamsConfig) {
        globalP = globalBaseParamsConfig(url, @{});
    }
    NSMutableDictionary *dict = params.mutableCopy;
    [dict removeObjectsForKeys:[globalP allKeys]];
    NSMutableArray *keys = [dict allKeys].mutableCopy;
    [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 hash] > [obj2 hash] ? NSOrderedAscending : NSOrderedDescending;
    }];
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp appendString:obj];
        [temp appendString:[NSString stringWithFormat:@"%@", params[obj]]];
    }];
    return temp.copy;
}

- (void)_nt_checkCacheUrl:(NSString *)urlString params:(nullable NSDictionary *)params cacheType:(NTNetCacheType)cacheType successed:(void(^)(id object, BOOL isCache))successed requsetConfig:(dispatch_block_t)requsetConfig{
    
    switch (cacheType) {
        case NTNetCacheTypeNone: {
            NT_BLOCK(requsetConfig);
            break;
        }
        case NTNetCacheTypeIngorCache: {
            NT_BLOCK(requsetConfig);
            break;
        }
        case NTNetCacheTypeUseCahceFirst: {
            [self _nt_searchCache:urlString params:params searchResultConfig:^(id cacheObject) {
                if (cacheObject) {
                    NT_BLOCK(successed, cacheObject, YES);
                }else{
                    NT_BLOCK(requsetConfig);
                }
            }];
            break;
        }
        case NTNetCacheTypeUseCacheAndRequst: {
            [self _nt_searchCache:urlString params:params searchResultConfig:^(id cacheObject) {
                if (cacheObject) NT_BLOCK(successed, cacheObject, YES);
            }];
            NT_BLOCK(requsetConfig);
            break;
        }
    }
}

- (void)_nt_searchCache:(NSString *)url params:(NSDictionary *)params searchResultConfig:(void(^)(id cacheObject))config{
    NSString *cacheKey = [self _nt_getCacheKeyWithUrl:url params:params];
    if (!cacheKey.length) NT_BLOCK(config, nil);
    [[self _nt_netCacheTool] nt_objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
        NT_BLOCK(config, object);
    }];
}

- (BOOL)_nt_preparRequesetWithURL:(NSString *)urlString faileConfig:(void(^)(NSError * error))faileConfig{
    NSAssert(urlString.length, @"url不能为空");
    if ([NTNetTool nt_getNetStatus] == NTNetStatusTypeNotReachable) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:@{@"CodeDes" : @"网络似乎已经断开链接"}];
        NT_BLOCK(faileConfig, error);
        return NO;
    }
    [self _nt_mangerConfig];
    return YES;
}

- (void)_nt_getDataSuccessedWithResponseObject:(id)responseObject url:(NSString *)url params:(NSDictionary *)params successed:(void(^)(id object, BOOL isCache))successed{
    responseObject = [self _nt_checkResponseObject:responseObject url:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self _nt_saveCache:url params:params value:responseObject];
    });
    NT_BLOCK(successed, responseObject, NO);
}

- (void)_nt_getDataFailedWithError:(NSError *)error failed:(void(^)(NSError * error))failed{
    NT_BLOCK(failed, error);
}


- (NSString *)_nt_checkURLString:(NSString *)urlString{
    if (_ignorGlobalBaseURL) return urlString;
    NSString *baseURL;
    if (globalBaseURLConfig) baseURL = globalBaseURLConfig(urlString);
    if (baseURL.length) urlString = [baseURL stringByAppendingString:urlString];
    return urlString;
}

- (NSDictionary *)_nt_checkParams:(NSString *)url subParams:(NSDictionary *)subParams{
    if (_ignorGlobalBaseParams) return subParams;
    NSDictionary *baseParams;
    if (globalBaseParamsConfig) baseParams = globalBaseParamsConfig(url, subParams ?: @{});
    if (baseParams.count) subParams = subParams ? [subParams nt_addEntriesFromDictionary:baseParams] : baseParams;
    return subParams;
}

- (id)_nt_checkResponseObject:(id)responseObject url:(NSString *)url{
    if (_ignorGlobalResponseHandle && !_responseHandleConfig) return responseObject;
    if (globalResponseHandleConfig && !_ignorGlobalResponseHandle) responseObject = globalResponseHandleConfig(url, responseObject);
    if (_responseHandleConfig) responseObject = _responseHandleConfig(url, responseObject);
    return responseObject;
}


@end

NSString * const NTNetStatusDidChangeNotification = @"com.alamofire.networking.reachability.change";
