//
//  NTCacheTool.h
//  NewCenterWeather
//
//  Created by wazrx on 16/6/30.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NTCacheToolType) {
    NTCacheToolTypeMemoryAndDisk,
    NTCacheToolTypeMemory,
    NTCacheToolTypeDisk
};

@interface NTCacheTool : NSObject

@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *path;

#pragma mark - initialze

+ (instancetype)nt_cacheToolWithType:(NTCacheToolType)type name:(NSString *)name;

+ (instancetype)nt_cacheToolWithType:(NTCacheToolType)type path:(NSString *)path;

+ (instancetype)nt_cacheToolWithType:(NTCacheToolType)type path:(NSString *)path inlineThreshold:(NSUInteger)inlineThreshold;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

#pragma mark - add

- (void)nt_setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;


- (void)nt_setObject:(nullable id<NSCoding>)object forKey:(NSString *)key withBlock:(nullable void(^)(void))block;

#pragma mark - delete

- (void)nt_removeObjectForKey:(NSString *)key;


- (void)nt_removeObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key))block;


- (void)nt_removeAllObjects;


- (void)nt_removeAllObjectsWithBlock:(void(^)(void))block;


- (void)nt_removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;

#pragma mark - check

- (BOOL)nt_containsObjectForKey:(NSString *)key;


- (void)nt_containsObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, BOOL contains))block;


- (nullable id<NSCoding>)nt_objectForKey:(NSString *)key;

- (void)nt_objectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, __nullable id<NSCoding> object))block;

#pragma mark - for memoryCache

@property (readonly) NSUInteger memoryTotalCount;

@property (readonly) NSUInteger memoryTotalCost;

@property NSUInteger memoryCountLimit;

@property NSUInteger memoryCostLimit;

@property NSTimeInterval memoryAgeLimit;

@property NSTimeInterval memoryAutoTrimInterval;

@property BOOL shouldRemoveAllObjectsOnMemoryWarning;

@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;

- (void)nt_setMemoryWarningConfig:(void(^)(NTCacheTool *cacheTool))memoryWarningConfig enteringBackgroundConfig:(void(^)(NTCacheTool *cacheTool))enteringBackgroundConfig;

@property BOOL releaseOnMainThread;

@property BOOL releaseAsynchronously;

- (void)nt_memoryTrimToCount:(NSUInteger)count;


- (void)nt_memoryTrimToCost:(NSUInteger)cost;


- (void)nt_memoryTrimToAge:(NSTimeInterval)age;

#pragma mark - for diskCache

@property (readonly) NSUInteger inlineThreshold;

@property NSUInteger diskCountLimit;

@property NSUInteger diskCostLimit;

@property NSTimeInterval diskAgeLimit;

@property NSUInteger freeDiskSpaceLimit;

@property NSTimeInterval diskAutoTrimInterval;

@property BOOL errorLogsEnabled;

- (void)nt_setCustomFileNameConfig:(NSString *(^)(NSString *key))config;

- (NSInteger)nt_diskTotalCount;

- (void)nt_diskTotalCountWithBlock:(void(^)(NSInteger totalCount))block;

- (NSInteger)nt_diskTotalCost;

- (void)nt_diskTotalCostWithBlock:(void(^)(NSInteger totalCost))block;

- (void)nt_diskTrimToCount:(NSUInteger)count;

- (void)nt_diskTrimToCount:(NSUInteger)count withBlock:(void(^)(void))block;

- (void)nt_diskTrimToCost:(NSUInteger)cost;

- (void)nt_diskTrimToCost:(NSUInteger)cost withBlock:(void(^)(void))block;

- (void)nt_diskTrimToAge:(NSTimeInterval)age;

- (void)nt_diskTrimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block;

+ (nullable NSData *)nt_getExtendedDataFromObject:(id)object;

+ (void)nt_setExtendedData:(nullable NSData *)extendedData toObject:(id)object;

@end

NS_ASSUME_NONNULL_END
